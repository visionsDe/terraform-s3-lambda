output "sqs_queue_url" {
  value = aws_sqs_queue.s3-notifications-sqs.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.s3-notifications-sqs.arn
}
output "s3_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "s3_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}