terraform {
    required_providers {
        aws = {      
          source  = "hashicorp/aws"      
          version = "5.0.1"      
        }
    }
    backend "s3" {
    bucket         	   = "lambda-s3-terraform" #This you can change with your bucket name
    key              	 = "state/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table     = "terraform_tf_lock" #This you can update with you dynamodb
  } 
}

provider "aws" {
  region = var.region
}

