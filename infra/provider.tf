terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  cloud {
    organization = "bemtech-io"
    workspaces {
      name = "eks-enterprise-platform-dev"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = local.tags
  }
}