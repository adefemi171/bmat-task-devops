provider "aws" {
  region = var.region_main
}

resource "aws_s3_bucket" "test_terraform_state" {
  bucket = "test-bmat-devops-task-236"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  } # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


resource "aws_dynamodb_table" "test_terraform_state_locks" {
  name         = "test-bmat-devops-locks-1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}