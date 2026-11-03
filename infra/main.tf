module "main_vpc" {
  source   = "./modules/vpc"
  az_count = var.az_count
  cidr     = var.cidr
  vpc_name = "${var.project_name}-${var.environment}-vpc"
  environment = var.environment
}
