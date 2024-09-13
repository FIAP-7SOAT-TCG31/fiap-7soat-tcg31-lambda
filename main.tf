provider "aws" {
  region = "us-east-1"
}

####################################
# FIAP BURGER AUTH LAMBDA FUNCTION #
####################################

resource "aws_lambda_function" "fiap_burger_auth_lambda" {
  function_name = "fiap-burger-auth-lambda"
  image_uri     = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/fiap_burger_auth_lambda:${var.image_version}"
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


#########################
# GATEWAY CONFIGURATION #
#########################

resource "aws_api_gateway_rest_api" "fiap_burger_identity" {
  name        = "fiap_burger_identity"
  description = "Identity Provider integration for FiapBurger"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.fiap_burger_identity.id
  parent_id   = aws_api_gateway_rest_api.fiap_burger_identity.root_resource_id
  path_part   = aws_lambda_function.fiap_burger_auth_lambda.function_name
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.fiap_burger_identity.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.fiap_burger_identity.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fiap_burger_auth_lambda.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.fiap_burger_identity.id
  resource_id   = aws_api_gateway_rest_api.fiap_burger_identity.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.fiap_burger_identity.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fiap_burger_auth_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.fiap_burger_identity.id
  stage_name  = "dev"
}

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fiap_burger_auth_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.fiap_burger_identity.execution_arn}/*/*"
}
