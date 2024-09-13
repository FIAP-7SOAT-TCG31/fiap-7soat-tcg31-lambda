provider "aws" {
  region = "us-east-1"
}

####################################
# FIAP BURGER AUTH LAMBDA FUNCTION #
####################################

locals {
  aws_account_id = "287574492696"
  image_url      = "dkr.ecr.us-east-1.amazonaws.com/fiap_burger_auth_lambda"
}

resource "aws_lambda_function" "fiap_burger_auth_lambda" {
  function_name = "fiap-burger-auth-lambda"
  image_uri     = "${local.aws_account_id}.${local.image_url}:${var.image_version}"
  role          = "arn:aws:iam::${local.aws_account_id}:role/LabRole"
  package_type  = "Image"

  timeout = 180
  environment {
    variables = {
      DUMMY = "DUMMY"
    }
  }
}
