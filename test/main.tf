provider "aws" {
  region = "us-east-1"
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

// VPC for us-east-1
resource "aws_vpc" "test" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.id
}

// Getting all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  state = "available"
}

// Creating Public Subnet
resource "aws_subnet" "subnet_public_1" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Subnet Public 1"
  }
}

resource "aws_subnet" "subnet_public_2" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Subnet Public 2"
  }
}

resource "aws_subnet" "subnet_public_3" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Subnet Public 3"
  }
}


// Creating Private Subnet
resource "aws_subnet" "subnet_private_1" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Subnet Private 1"
  }
}

resource "aws_subnet" "subnet_private_2" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Subnet Private 2"
  }
}

resource "aws_subnet" "subnet_private_3" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Subnet Private 3"
  }
}


# create public route table
resource "aws_route_table" "net_route_public" {
  vpc_id = aws_vpc.test.id
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

# route associations public
resource "aws_route_table_association" "main_public_1_a" {
  subnet_id      = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.net_route_public.id
}
resource "aws_route_table_association" "main_public_2_a" {
  subnet_id      = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.net_route_public.id
}
resource "aws_route_table_association" "main_public_3_a" {
  subnet_id      = aws_subnet.subnet_public_3.id
  route_table_id = aws_route_table.net_route_public.id
}

# ElastiCache cluster inside of a VPC. 
# resource "aws_elasticache_subnet_group" "bar" {
#   name       = "tf-test-cache-subnet"
#   subnet_ids = [aws_subnet.foo.id]
# }

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = aws_vpc.test.id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
    description = "Allow connection to anywhere on the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 22 from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}


resource "aws_launch_configuration" "main_launchconfig" {
  name_prefix     = "main-launchconfig"
  image_id        = data.aws_ami.ubuntu_image.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow-ssh.id]
  user_data       = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }
}

resource "aws_autoscaling_group" "main_autoscaling" {
  name                      = "main-autoscaling"
  vpc_zone_identifier       = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]
  launch_configuration      = aws_launch_configuration.main_launchconfig.name
  min_size                  = 1
  max_size                  = 5
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}

# scale up alarm
resource "aws_autoscaling_policy" "cpu_policy_scale_up" {
  name                   = "main-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.main_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "job_too_high" {
  alarm_name          = "job-too-high"
  alarm_description   = "This metric monitors ec2 cpu for high utilization on the worker and scale up as need be"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "4" # Number of Jobs in Queue

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main_autoscaling.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy_scale_up.arn]
}


# scale down alarm
resource "aws_autoscaling_policy" "cpu_policy_scale_down" {
  name                   = "main-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.main_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "job_too_low" {
  alarm_name          = "job-too-low"
  alarm_description   = "This metric monitors ec2 cpu for high utilization on the worker and scale down as need be"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "0" # Number of Jobs in Queue
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main_autoscaling.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy_scale_down.arn]
}
