terraform {
  backend "s3" {
    bucket         = "bmat-devops-task-235"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bmat-devops-locks-1"
    encrypt        = true
  }
}