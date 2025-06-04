locals {
  common_tags = {
    project     = var.project_name
    Environment = upper(var.environment)
    ManagedBy   = "terraform"
  }
}