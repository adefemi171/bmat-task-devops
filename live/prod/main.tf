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

module "this" {
  source = "../../modules/services"
  
  name = "Autoscale-with-lc"
}

