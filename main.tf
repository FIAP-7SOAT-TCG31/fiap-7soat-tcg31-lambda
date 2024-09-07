provider "aws" {
  region = "us-east-1"
}

locals {
  aws_account_id = "287574492696"
  image_url      = "dkr.ecr.us-east-1.amazonaws.com/fiap_burger_lambda"
}

resource "aws_lambda_function" "hello_world" {
  function_name = "hello-world"
  image_uri     = "${local.aws_account_id}.${local.image_url}:latest"
  role          = "arn:aws:iam::${local.aws_account_id}:role/LabRole"
  package_type  = "Image"
}
