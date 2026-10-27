# CloudScope — Deployed Architecture (based on supplied Amazon Q report)

## High-level architecture

```mermaid
flowchart TD
    B[Browser / React frontend] -->|HTTPS direct API calls| G[API Gateway v2 HTTP API — us-east-1]
    G --> L1[aws-rcm-get-resources]
    G --> L2[aws-rcm-get-scan-results]
    G --> L3[aws-rcm-get-credits]
    G --> L4[aws-rcm-user-settings]
    G -->|POST /scan| SC[aws-rcm-scanner]
    L1 --> R[(resources)]
    L2 --> S[(scan_results)]
    L4 --> U[(user_settings)]
    L3 --> C[(aws_rcm_credit_data)]
    E1[EventBridge Scheduler daily] --> SC
    E2[EventBridge Scheduler daily] --> CS[aws-rcm-credits-scanner]
    SC --> CE[AWS Cost Explorer]
    SC --> AWS[AWS resource APIs]
    CS --> CE
    SC --> R
    SC --> S
    CS --> C
```

## Reported deployment facts

- API Gateway v2 HTTP API and backend compute are in `us-east-1`.
- Resource discovery spans `us-east-1` and `ap-south-1`.
- DynamoDB tables are in `us-east-1`, on PAY_PER_REQUEST billing.
- Frontend hosting on Amplify 
- Cognito user pool is reported as present. 
- Schedules: `aws-rcm-scheduled-scan` and `rcm-schedule-credit-scan`, each running at `rate(24h)`.

## Lambda functions

| Function | Reported memory | Timeout | Role |
|---|---:|---:|---|
| `aws-rcm-scanner` | 256 MB | 300 sec | Resource discovery and billing collection |
| `aws-rcm-credits-scanner` | 256 MB | 60 sec | Credit history collection |
| `aws-rcm-get-resources` | 128 MB | 30 sec | Read resource inventory |
| `aws-rcm-get-scan-results` | 128 MB | 30 sec | Read latest scan/billing data |
| `aws-rcm-get-credits` | 256 MB | 30 sec | Read credit history |
| `aws-rcm-user-settings` | 128 MB | 30 sec | Read/update preferences |

## DynamoDB tables

- `resources`: PK `resource_id` (String); report observed 27 items.
- `scan_results`: PK `scan_id` (String); latest record uses key `LATEST`.
- `aws_rcm_credit_data`: PK `pk` (String), SK `sk` (String); report observed 1,945 items.
- `user_settings`: schema not fully detailed in the supplied report.

