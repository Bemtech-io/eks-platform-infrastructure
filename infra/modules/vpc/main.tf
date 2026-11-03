
locals {
  available_azs     = data.aws_availability_zones.available.names
  possible_az_count = min(var.az_count, length(data.aws_availability_zones.available.names))
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr
  azs  = slice(local.available_azs, 0, local.possible_az_count)

  public_subnets                         = [for i in range(local.possible_az_count) : cidrsubnet(var.cidr, 8, i)]
  private_subnets                        = [for i in range(local.possible_az_count) : cidrsubnet(var.cidr, 4, i + 4)]
  database_subnets                       = [for i in range(local.possible_az_count) : cidrsubnet(var.cidr, 8, i + 192)]
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = var.environment == "dev"
  single_nat_gateway = var.environment == "dev"

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

## add configuration for the prod and staging to use a regional nat gateway

resource "aws_nat_gateway" "main_nat_gateway" {
  count             = var.environment == "dev" ? 0 : 1
  vpc_id            = module.vpc.vpc_id
  availability_mode = "regional"
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
  depends_on = [module.vpc.igw_id]
}

resource "aws_route" "private_regional_nat_route" {
  count                  = var.environment == "dev" ? 0 : length(module.vpc.private_route_table_ids)
  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat_gateway[0].id
}