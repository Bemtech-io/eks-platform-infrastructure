locals {
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Owner       = "BemTech"
  }
  available_environment = ["dev", "staging", "prod"]
}