output "bastion_public_IP" {
  value = module.ec2.public_ip
}