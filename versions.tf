terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "tfstate-fiap-7soat-f4-tcg31"
    key    = "global/s3/auth-lambda.tfstate"
    region = "us-east-1"
  }
}
