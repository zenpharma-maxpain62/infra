output "bastion_public_IP" {
  value = module.ec2.public_ip
}

output "security_group_id" {
  description = "Security group ID of the EKS node group"
  value       = aws_security_group.ec2.id
}