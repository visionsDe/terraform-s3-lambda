variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "s3_bucket_id" {
  type = string
}

variable "lambda_arn" {
  type = string
}