# dynamo table name: test-bmat-devops-locks-1
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.test_terraform_state_locks.name
  description = "The name of the DynamoDB table"
}

# Bucket name: test-bmat-devops-task-236
output "s3_name" {
  value       = aws_s3_bucket.test_terraform_state.id
  description = "The name of the DynamoDB table"
}

# Bucket ARN: arn:aws:s3:::test-bmat-devops-task-236
output "s3_bucket_arn" {
  value       = aws_s3_bucket.test_terraform_state.arn
  description = "The ARN of the S3 bucket"
}