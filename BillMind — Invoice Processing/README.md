# BillMind — Serverless Invoice Processing

BillMind is a serverless application that lets authenticated users upload invoice documents, extract structured information with Amazon Textract, review the results, and save invoice records.

## Features
- Upload supported PDF and image documents for extraction.
- Extract invoice text and key-value fields with Amazon Textract.
- Normalize common fields such as vendor name, invoice number, dates, total amount, and currency.
- Review and correct extracted fields before saving.
- List, view, update, and delete invoice records through authenticated API endpoints.
- Store uploaded files in Amazon S3 and invoice metadata in Amazon DynamoDB.

## Architecture
**React frontend → Amazon Cognito authentication → API Gateway HTTP API → AWS Lambda → Amazon S3, Amazon Textract, and Amazon DynamoDB**

See [ARCHITECTURE.md](ARCHITECTURE.md) for the component overview and request flows.

## Technology stack

| Layer | Technology |
|---|---|
| Frontend | React, AWS Amplify Auth |
| Authentication | Amazon Cognito |
| API | Amazon API Gateway HTTP API |
| Compute | AWS Lambda |
| File storage | Amazon S3 |
| Document extraction | Amazon Textract |
| Database | Amazon DynamoDB |
| Region in project notes | `ap-south-1` |

## API capabilities

| Method | Route | Purpose |
|---|---|---|
| `POST` | `/invoices/upload` | Upload a document and start extraction |
| `GET` | `/invoices` | List invoices for the authenticated user |
| `GET` | `/invoices/{invoiceId}` | Retrieve one invoice |
| `PUT` | `/invoices/{invoiceId}` | Save reviewed invoice fields |
| `DELETE` | `/invoices/{invoiceId}` | Delete an invoice record and associated file |

All routes are documented as requiring a Cognito JWT. Verify route authorization in the deployed API before relying on this statement.

## Engineering highlights
- A normalization layer maps variable Textract labels to common invoice fields.
- The upload handler validates the encoded request and supported content types.
- The documented flow removes the uploaded S3 object if extraction or the initial database write fails.
- Invoice records are partitioned by user identifier in DynamoDB, according to the supplied design notes.

## Repository documentation
- [Architecture](ARCHITECTURE.md)
- [Project case study](CASE_STUDY.md)
- [Resume and interview notes](RESUME.md)
- [Publish checklist](PUBLISH_CHECKLIST.md)

## Deployment and cost notes
The project notes describe a serverless deployment in `ap-south-1`. This README does not include a one-click deployment procedure because the infrastructure templates, exact environment variables, and full setup steps were not supplied with the notes. Add verified setup instructions before inviting others to deploy it.

Any cost figures should be treated as estimates for low demo usage, not as a guaranteed monthly cost. Check current AWS pricing and your own usage before making cost claims.

## Security before publishing
Never commit AWS access keys, secret keys, Cognito tokens, `.env` files, real invoice files, or real extracted invoice data. Confirm that no sensitive identifiers or credentials are embedded in code or screenshots.
