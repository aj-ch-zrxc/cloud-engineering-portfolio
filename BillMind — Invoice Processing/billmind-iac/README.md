# BillMind V1 — Public Infrastructure as Code

BillMind is a personal bill and invoice management application. The documented AWS design uses Cognito, API Gateway, Lambda, DynamoDB, S3, and Textract.

## Included

- `cloudformation/main.yaml` — root stack
- `cloudformation/dynamodb.yaml` — bill and invoice metadata tables
- `cloudformation/storage.yaml` — private invoice document bucket
- `cloudformation/api.yaml` — Lambda functions, API Gateway routes, Cognito JWT authorizer, and execution roles
- `parameters/example.json` — safe placeholder configuration
- `scripts/deploy.sh` — basic deployment helper
- `docs/assumptions.md` — items to verify before deployment

Region described by the project documentation: `ap-south-1` (Mumbai).

## Before deployment

This is a public portfolio starter, not a verified export of the live account. The documentation does not establish exact DynamoDB key schemas, all API routes, Lambda ZIP contents, handler names, existing CloudFormation ownership, or deployed Cognito IDs.

1. Replace all `REPLACE_...` values in the example parameters.
2. Confirm the Cognito User Pool and app client are in the target region.
3. Upload the Lambda ZIP packages to the configured artifact bucket and confirm the S3 keys.
4. Confirm each ZIP contains the configured handler and compatible dependencies.
5. Confirm the existing DynamoDB table key schema and indexes. The sample table schema uses `billId` and `invoiceId` partition keys plus `userId-index` GSIs; treat this as an assumption until verified.
6. Confirm whether the named tables and invoice bucket already exist. A new stack cannot automatically adopt resources that already exist.
7. Compare API routes and Lambda event parsing with the application code before deployment.
8. Run `cfn-lint` and CloudFormation validation.

The invoice bucket is an application resource. The artifact bucket is separate and is only used to distribute templates and Lambda packages.

## Deployment

Requires AWS CLI and `jq`. Review the script and parameters before use. The script can create or modify billable AWS resources and does not build Lambda ZIP files, create Cognito resources, or deploy the frontend.

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

No deployment has been performed as part of preparing this public package.
