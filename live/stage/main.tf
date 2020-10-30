provider "aws" {
  region = var.region_main
}

module "network" {
  source = "../../modules/services"

  name = var.name
}

module "security-group" {
  source        = "../../modules/services"

  name = "service-security-group"
}


# scale up alarm
resource "aws_autoscaling_policy" "cpu_policy_scale_up" {
  name                   = "main-cpu-policy"
  autoscaling_group_name = module.asg.this_autoscaling_group_name
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
    "AutoScalingGroupName" = module.asg.this_autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy_scale_up.arn]
}


# scale down alarm
resource "aws_autoscaling_policy" "cpu_policy_scale_down" {
  name                   = "main-cpu-policy-scaledown"
  autoscaling_group_name = module.asg.this_autoscaling_group_name
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
    "AutoScalingGroupName" = module.asg.this_autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy_scale_down.arn]
}