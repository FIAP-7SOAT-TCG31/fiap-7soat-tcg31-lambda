provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "fiap_burger_identity" {
  function_name = "fiap_burger_identity"
  image_uri     = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/fiap_burger_identity:${var.image_version}"
  role          = "arn:aws:iam::${var.aws_account_id}:role/LabRole"
  package_type  = "Image"

  timeout = 180
  environment {
    variables = {
      COGNITO_USER_POOL_ID   = var.cognito_user_pool_id
      COGNITO_CLIENT_ID      = var.cognito_client_id
      XAWS_ACCESS_KEY_ID     = var.aws_access_key_id
      XAWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
      XAWS_SESSION_TOKEN     = var.aws_session_token
    }
  }
}

output "fiap_burger_identity_invoke_arn" {
  description = "Function Invoke ARN"
  value       = aws_lambda_function.fiap_burger_identity.invoke_arn
  sensitive   = true
}

output "fiap_burger_identity_function_name" {
  description = "Function Name"
  value       = aws_lambda_function.fiap_burger_identity.function_name
}
