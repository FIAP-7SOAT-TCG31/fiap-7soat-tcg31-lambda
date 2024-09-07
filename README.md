```bash
aws ecr create-repository --repository-name hello-world --region us-east-1 --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE

# 

aws ecr delete-repository --repository-name hello-world

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 287574492696.dkr.ecr.us-east-1.amazonaws.com


docker tag gm50x/lambda-test:latest 287574492696.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest


aws lambda create-function \
  --function-name hello-world \
  --package-type Image \
  --code ImageUri=287574492696.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest \
  --role arn:aws:iam::287574492696:role/LabRole
```