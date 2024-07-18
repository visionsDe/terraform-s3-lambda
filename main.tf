
module "s3-sqs" {
    source = "./module/s3-sqs"
    project     = var.project
    environment = var.environment
  
}


module "eventbridge" {
  source = "./module/eventbridge"
  project     = var.project
  environment = var.environment
  s3_bucket_id = module.s3-sqs.s3_id
  lambda_arn = module.lambda.lambda_arn
}

module "lambda" {
  source = "./module/lambda"
  project     = var.project
  environment = var.environment
  s3_bucket_arn = module.s3-sqs.s3_arn
  sqs_queue_arn = module.s3-sqs.sqs_queue_arn
  
}