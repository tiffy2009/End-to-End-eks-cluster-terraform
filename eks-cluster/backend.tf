terraform {
  required_version = "~> 1.9.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }
  backend "s3" {
    bucket         = "mydevsecbucket"
    region         = "us-east-1"
    key            = "unitedeks/terraform.tfstate"
    dynamodb_table = "uniteddb"
    encrypt        = true
  }
}

provider "aws" {
  region     = var.aws-region
  # access_key = ""
  # secret_key = ""
}
