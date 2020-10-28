# VPC ID: vpc_id = vpc-0d437d18fb978fcf6
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}
