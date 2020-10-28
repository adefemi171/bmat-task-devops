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