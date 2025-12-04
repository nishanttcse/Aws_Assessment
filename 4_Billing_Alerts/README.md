# Task 4 — Billing & Free Tier Cost Monitoring

**Brief approach (4–6 lines)**:
- Enable AWS Cost Explorer and create a Billing Alarm using CloudWatch metric `EstimatedCharges` (namespace `AWS/Billing`) for your account and desired currency.
- Create a Budget (AWS Budgets) and enable email notifications at threshold (₹100).
- Enable Free Tier usage alerts via Billing console.

**Notes**:
- Billing metrics are only available in `us-east-1` for CloudWatch; set provider region accordingly when creating CloudWatch alarms.
- Terraform example provided below uses Alarm for `EstimatedCharges` and an AWS Budget resource.

