output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "bastion_publicIP" {
  description = "bastion host public IP"
  value = module.ec2.bastion_public_IP
}