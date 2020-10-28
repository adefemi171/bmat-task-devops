# VPC ID: vpc-0d437d18fb978fcf6
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}


output "this_security_group_id" {
  description = "The ID of the security group"
  value       = module.service_sg.this_security_group_id
}

output "this_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.service_sg.this_security_group_vpc_id
}

output "this_security_group_owner_id" {
  description = "The owner ID"
  value       = module.service_sg.this_security_group_owner_id
}

output "this_security_group_name" {
  description = "The name of the security group"
  value       = module.service_sg.this_security_group_name
}

output "this_security_group_description" {
  description = "The description of the security group"
  value       = module.service_sg.this_security_group_description
}