################################################################
## ECS
################################################################
locals {
  global_config = yamldecode(file("../settings/config.yaml"))
  product       = local.global_config["product"]
  ecs_myapp     = local.global_config[var.environment]["ecs"]["myapp_cluster"]
}

module "ecs" {
  source = "../../../../modules/ecs"

  product     = local.product
  environment = var.environment
  app_image   = local.ecs_myapp["application_image"]
  name        = local.ecs_myapp["name"]
}

# Note:
# Because it is automatically deployed from the pipeline, this app image will no longer be the source of truth.