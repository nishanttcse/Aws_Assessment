provider "aws" { region = "us-east-1" } # Billing metrics use us-east-1

variable "prefix" { type = string }

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name = "${var.prefix}_billing_alarm_100INR"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  metric_name = "EstimatedCharges"
  namespace   = "AWS/Billing"
  statistic = "Maximum"
  period = 21600
  threshold = 1.5  # Note: CloudWatch EstimatedCharges metric usually reports in USD. Adjust threshold accordingly or use Budget API.
  alarm_description = "Alert when estimated charges exceed threshold"
  alarm_actions = []
}

# Terraform aws_budgets is community; example using aws_budgets_budget (if provider supports)
resource "aws_budgets_budget" "monthly_budget" {
  name = "${var.prefix}_monthly_budget"
  budget_type = "COST"
  limit_amount = "1.5"
  limit_unit = "USD"
  time_unit = "MONTHLY"
  cost_filters = {}
  notification {
    comparison_operator = "GREATER_THAN"
    notification_type = "ACTUAL"
    threshold = 50
    threshold_type = "PERCENTAGE"
    subscriber {
      subscription_type = "EMAIL"
      address = "your-email@example.com"
    }
  }
}
