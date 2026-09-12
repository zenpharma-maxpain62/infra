variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name (dev, qa, prod)"
}

variable "region" {
  type        = string
  description = "AWS Region name"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "CIDR block for public subnet"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "CIDR block for private subnet"
}

variable "database_subnet_cidr" {
  type        = list(string)
  description = "CIDR block for database subnet"
}

