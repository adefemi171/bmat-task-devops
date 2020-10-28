terraform {
  backend "s3" {
    bucket         = "bmat-devops-task-234"
    key            = "stage/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bmat-devops-locks"
    encrypt        = true
  }
}