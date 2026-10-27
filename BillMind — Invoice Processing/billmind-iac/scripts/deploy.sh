#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-ap-south-1}"
STACK_NAME="${STACK_NAME:-billmind-test}"
PARAMS_FILE="${PARAMS_FILE:-parameters/example.json}"

command -v aws >/dev/null || { echo "AWS CLI is required" >&2; exit 1; }
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }
[[ -f "$PARAMS_FILE" ]] || { echo "Missing parameter file: $PARAMS_FILE" >&2; exit 1; }

echo "Target AWS identity:"
aws sts get-caller-identity --region "$REGION"
echo "Region: $REGION"
echo "Stack: $STACK_NAME"
echo "Parameters: $PARAMS_FILE"
echo "This script can create or modify billable AWS resources."
read -r -p "Type YES to continue: " answer
[[ "$answer" == "YES" ]] || { echo "Cancelled."; exit 1; }

mapfile -t PARAMS < <(jq -r '.[] | "\(.ParameterKey)=\(.ParameterValue)"' "$PARAMS_FILE")
ARTIFACT_BUCKET="$(jq -r '.[] | select(.ParameterKey=="ArtifactBucket") | .ParameterValue' "$PARAMS_FILE")"
ARTIFACT_PREFIX="$(jq -r '.[] | select(.ParameterKey=="ArtifactPrefix") | .ParameterValue' "$PARAMS_FILE")"

for f in main.yaml dynamodb.yaml storage.yaml api.yaml; do
  [[ -f "cloudformation/$f" ]] || { echo "Missing cloudformation/$f" >&2; exit 1; }
done

for f in dynamodb.yaml storage.yaml api.yaml; do
  aws s3 cp "cloudformation/$f" "s3://${ARTIFACT_BUCKET}/${ARTIFACT_PREFIX}/${f}" --region "$REGION"
done

aws cloudformation validate-template --template-body file://cloudformation/main.yaml --region "$REGION" >/dev/null
aws cloudformation deploy --template-file cloudformation/main.yaml --stack-name "$STACK_NAME" --parameter-overrides "${PARAMS[@]}" --capabilities CAPABILITY_NAMED_IAM --region "$REGION"
