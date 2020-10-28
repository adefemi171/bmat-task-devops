output "this_launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = module.asg.this_launch_configuration_id
}

output "this_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.asg.this_autoscaling_group_id
}

output "this_autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = module.asg.this_autoscaling_group_availability_zones
}

output "this_autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = module.asg.this_autoscaling_group_vpc_zone_identifier
}

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.asg.this_autoscaling_group_load_balancers
}

output "this_autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = module.asg.this_autoscaling_group_name
}

output "this_launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = module.asg.this_launch_configuration_name
}