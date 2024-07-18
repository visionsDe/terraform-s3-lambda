resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name                = "${var.project}-${var.environment}-eventbridge-rule"
  event_pattern       = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail      = {
      eventSource   = ["s3.amazonaws.com"]
      eventName     = ["PutObject"]
      requestParameters = {
        bucketName = [var.s3_bucket_id]
      }
    }
  })
}

# Connect EventBridge rule to Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.eventbridge_rule.name
  target_id = "invoke-lambda"
  arn       = "${var.lambda_arn}"
}