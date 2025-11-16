################################################################
## ALB
################################################################
locals {
  global_config    = yamldecode(file("../../../settings/config.yaml"))
  product          = local.global_config["product"]
  alb_myapp_config = local.global_config[var.environment]["elb"]["alb"]
}

module "alb_myapp" {
  source = "../../../../../../modules/ec2/elb/alb"

  for_each = { for listener, config in local.alb_myapp_config : listener => config }

  product       = local.product
  environment   = var.environment
  name          = each.value.name
  app_port      = each.value.app_port
  listener_port = each.value.listener_port
  protocol      = each.value.protocol
}
