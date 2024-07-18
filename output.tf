output "s3_id" {
  value = module.s3-sqs.s3_id
}

output "s3_arn" {
  value = module.s3-sqs.s3_arn
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "sqs_queue_arn" {
  value = module.s3-sqs.sqs_queue_arn
}