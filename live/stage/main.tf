provider "aws" {
  region = var.region_main
}

module "network" {
  source = "../../modules/network"

  name = var.name
}

module "security-group" {
  source        = "../../modules/network"

  name = "service-security-group"
}