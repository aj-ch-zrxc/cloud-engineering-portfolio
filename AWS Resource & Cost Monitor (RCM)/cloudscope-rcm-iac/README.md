# CloudScope RCM — Public Infrastructure as Code

CloudScope RCM is a personal AWS resource and cost monitor. Its intended scope is to show active AWS resources, actual costs, cost drivers, and estimates where AWS provides reliable data.

## Architecture scope

- CloudFormation root stack with nested templates.
- DynamoDB tables for scan results, resources, user settings, and credit-related data.
- Lambda functions for scanning, resource retrieval, settings, scan results, and credit data.
- API Gateway HTTP API.
- EventBridge scheduled scan trigger.
- Cognito authorization is intended to be configured before public/production exposure.

There is **no application S3 bucket** in this design. S3 may still be used externally to host nested CloudFormation templates and Lambda ZIP artifacts during deployment.

## Files

- `cloudformation/main.yaml` — root stack
- `cloudformation/dynamodb.yaml` — DynamoDB tables
- `cloudformation/iam.yaml` — Lambda execution roles and policies
- `cloudformation/lambda.yaml` — Lambda functions
- `cloudformation/apigateway.yaml` — HTTP API and routes
- `cloudformation/eventbridge.yaml` — scheduled scanner trigger
- `parameters/example.json` — placeholder configuration
- `scripts/deploy.sh` — simple template validation and deployment helper
- `docs/assumptions.md` — known assumptions and pre-deployment checks

## Before deployment

1. Confirm the intended AWS account and region.
2. Supply artifact bucket names and upload the nested templates and Lambda ZIP packages to the configured keys.
3. Confirm the deployed Lambda names, handlers, environment variables, and table schemas match the application code.
4. Configure a Cognito User Pool and app client, then add JWT authorization to the routes before exposing the API.
5. If named DynamoDB tables already exist, decide whether to import them, keep them managed by an existing stack, or use new names. A normal create deployment cannot automatically adopt an existing table.
6. Run `cfn-lint` and CloudFormation validation before deployment.

## Status

Portfolio starter, not a verified deployment bundle. The included templates are a cleaned starting point based on the supplied CloudScope files; review the assumptions and validate the complete stack before use. No deployment has been performed.
