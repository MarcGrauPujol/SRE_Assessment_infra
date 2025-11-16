################################################################################
# ECS - Cluster
################################################################################
resource "aws_ecs_cluster" "main" {
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "ecs-cluster",
    var.name,
    module.global_settings.region_short_name)
}
