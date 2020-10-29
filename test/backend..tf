terraform {
  backend "s3" {
    bucket         = "test-bmat-devops-task-236"
    key            = "test/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "test-bmat-devops-locks-1"
    encrypt        = true
  }
}