provider "aws" {
  region = var.region_main
}

module "network" {
  source = "../../modules/network"

  name = var.name

  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# module "security-group" {
#   source        = "../../modules/security-group"
#   instance_type = "t2.micro"

#   name = "service-security-group"
# }