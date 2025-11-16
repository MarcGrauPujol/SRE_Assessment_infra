################################################################
## VPC
################################################################
locals {
  global_config = yamldecode(file("../../settings/config.yaml"))
  product       = local.global_config["product"]
  vpc_config    = local.global_config[var.environment]["network"]["vpc"][var.vpc_name]
}

module "vpc" {
  source = "../../../../../modules/network/vpc"

  product     = local.product
  environment = var.environment
  vpc_name    = var.vpc_name
  cidr        = local.vpc_config["cidr"]
}
