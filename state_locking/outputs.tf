# dynamo table name: bmat-devops-locks
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_state_locks.name
  description = "The name of the DynamoDB table"
}

# Bucket name: bmat-devops-task-234
output "s3_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "The name of the DynamoDB table"
}

# Bucket ARN: arn:aws:s3:::bmat-devops-task-234
output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}