variable "region_main" {
  type    = string
  default = "us-east-1"
}

variable "lcname" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "asgname" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}
variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}