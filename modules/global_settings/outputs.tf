output "region_short_name" {
  description = "Current AWS region short name"
  value       = local.aws_region_mapping[data.aws_region.current.id]
}