provider "aws" {
  region  = var.region_main
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # version = "v1.44.0"

  name = var.name

  cidr            = var.cidr

  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  
  enable_nat_gateway = true
  enable_vpn_gateway = true

   tags = {
    Terraform = "true"
    Environment = "stage"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "net_route_public" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Main-Route-Table"
  }
}

// route associations public
# resource "aws_route_table_association" "main_public_1_a" {
#   subnet_id      = [module.vpc.public_subnets]
#   route_table_id = aws_route_table.net_route_public.id
# }

# resource "aws_route_table_association" "main_public_1_b" {
#   gateway_id     = aws_internet_gateway.igw.id
#   route_table_id = aws_route_table.net_route_public.id
# }