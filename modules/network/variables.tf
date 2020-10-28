variable "region_main" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}


variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}