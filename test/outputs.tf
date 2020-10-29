# vpc = vpc-0a90458a3377a6953
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.test.id
}