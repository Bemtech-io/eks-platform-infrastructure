variable "cidr" {
  type        = string
  description = "The IPv4 CIDR block for the VPC (e.g., 10.0.0.0/16)"
}

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to utilize"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "eks-enterprise-platform"
}


variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
  validation {
    condition     = contains(local.available_environment, var.environment)
    error_message = "Invalid environment"
  }
}

