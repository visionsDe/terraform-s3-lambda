
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_deployment.zip"
}

# Lambda function
resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.lambda.output_path
  function_name = "${var.project}-${var.environment}-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

}


# IAM role for Lambda execution
resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-${var.environment}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

}


# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "s3_invoke_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.s3_bucket_arn}"
}


resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = "${var.sqs_queue_arn}"
  function_name    = aws_lambda_function.lambda.arn
  enabled          = true
}

# IAM policy for Lambda to access S3 and SQS
resource "aws_iam_policy" "lambda_policy" {
  name        = "example-lambda-policy"
  description = "IAM policy for Lambda to access S3 and SQS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:HeadObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = "${var.sqs_queue_arn}"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Attach the AWSLambdaBasicExecutionRole managed policy to the role
resource "aws_iam_role_policy_attachment" "execution_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}