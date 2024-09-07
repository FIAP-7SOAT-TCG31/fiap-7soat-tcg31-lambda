```bash
# Code to Create ECR
aws ecr create-repository --repository-name fiap_burger_auth_lambda --region us-east-1 --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE
```