variable "vpc_name" {
  type        = string
  description = "Name prefix for the VPC and its resources"
}

variable "cidr" {
  type        = string
  description = "The IPv4 CIDR block for the VPC (e.g., 10.0.0.0/16)"

  validation {
    condition     = can(cidrnetmask(var.cidr))
    error_message = "The cidr variable must be a valid IPv4 CIDR block (e.g., '10.0.0.0/16')."
  }
}

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to utilize"
  validation {
    condition = var.az_count >= 2
    error_message = "Invalid availability zones count at least 2"
  }
}


variable "environment" {
  type        = string
  description = "Environment of the vpc"
}
