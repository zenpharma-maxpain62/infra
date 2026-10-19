variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name (dev, qa, prod)"
}


variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}