provider "aws" {
  region  = var.region_main
}

data "aws_ami" "ubuntu_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "template_file" "user_data" {
  template = "${file("init-script.sh")}"
}


# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # version = "v1.44.0"

  name = var.name

  cidr            = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true

   tags = {
    Terraform = "true"
    Environment = "stage"
  }
}


# Security Group Module
module "service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.name
  description = "Security group that allows ssh and all egress traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow port 22 from anywhere"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


# ASG Module
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "service-autoscaling-group"

  # Launch Configuration
  lc_name = var.lcname

  image_id        = data.aws_ami.ubuntu_image.id
  instance_type   = "t2.micro"
  security_groups = [module.service_sg.this_security_group_owner_id]
  user_data       = data.template_file.user_data.rendered

  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    }
  ]

  # Auto Scaling Group
  asg_name            = var.asgname
  vpc_zone_identifier = [var.public_subnets] #need input
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = 0
  health_check_type   = "EC2"
  force_delete        = true

  tags = [
    {
      key                 = "Environment"
      value               = "stage"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "qa"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "prod"
      propagate_at_launch = true
    }
  ]
}