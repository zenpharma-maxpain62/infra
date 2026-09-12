variable "project" {
  type = string
  description = "Project name"
}

variable "env" {
  type = string
  description = "Environment name (dev, qa, prod)"
}

variable "repositories" {
  type = list(string)
  description = "List of ECR repository names to create"
}