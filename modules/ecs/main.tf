################################################################################
# Global Settings
################################################################################
module "global_settings" {
  source = "../global_settings"
}

################################################################################
# Task Definition
################################################################################
module "task_definition" {
  source = "./task_definition"

  aws_region_mapping = module.global_settings.region_short_name
  environment        = var.environment
  product            = var.product
  ecs_task_name      = var.name
  app_image          = var.app_image
}

################################################################################
# Task Service
################################################################################
module "service" {
  source = "./service"

  product                 = var.product
  environment             = var.environment
  name                    = var.name
  aws_region_mapping      = module.global_settings.region_short_name
  ecs_cluster_id          = aws_ecs_cluster.main.id
  ecs_task_definition_arn = module.task_definition.ecs_task_definition_arn

  depends_on = [module.task_definition, aws_ecs_cluster.main]
}
