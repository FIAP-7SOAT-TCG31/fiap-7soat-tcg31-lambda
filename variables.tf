variable "cognito_user_pool_id" {
  description = "Cognito User Pool"
  default     = ""
  sensitive   = true
}

variable "cognito_client_id" {
  description = "Client Id to access Cognito"
  default     = ""
  sensitive   = true
}
