variable "project" {
  type = string
  description = "Project name"
}

variable "env" {
  type = string
  description = "Environment name (dev, qa, prod)"
}

variable "vpc_id" {
  type = string
  description = "VPC ID for the EKS cluster"
}

variable "subnet_ids" {
  type = string
  description = "Subnet IDs for EKS nodes"
}

variable "kubernetes_version" {
  type = string
  default = "1.35"
  description = "Kubernetes version for the EKS cluster"
}

variable "instance_types" {
  type = list(string)
  description = "EC2 instance types for the node group"
  default = [ "t3.medium" ]
}

variable "desired_size" {
  type = number
  default = 2
  description = "Desired number of worker nodes"
}

variable "min_size" {
  type = number
  default = 1
  description = "Minimum number of worker nodes"
}

variable "max_size" {
  type = number
  default = 3
  description = "Maximum number of worker nodes"
}