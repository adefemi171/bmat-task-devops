provider "aws" {
  region = var.region_main
}

# Security Group Module
module "service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.name
  description = "Security group that allows ssh, redis and all egress traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.cidr
  egress_cidr_blocks  = var.cidr
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH port"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      description = "Redis Port"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow port 22 from anywhere"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}