output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw
}

# output "vpc_main_route_table_id" {
#   description = "The ID of the main route table associated with this VPC"
#   value       = aws_route_table_association.main_public_1_a.id
# }

# output "public_route_table_association_ids" {
#   description = "The list of IDs of the public route table association"
#   value       = aws_route_table.net_route_public.id
# }