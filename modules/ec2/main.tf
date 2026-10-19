resource "aws_security_group" "ec2" {
  name        = "${var.project}-${var.env}-ec2-sg"
  description = "Security group for ec2 bastion instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access for bastion host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.env}-ec2-sg"
    Project = var.project
    Env     = var.env
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.1"

  name = "zenpharma-bastion"

  instance_type               = "t3.micro"
  key_name                    = "dpp-key"
  subnet_id                   = var.subnet_id
  security_group_name         = aws_security_group.ec2.name
  associate_public_ip_address = true

  tags = {
    Project = var.project
    Env     = var.env
  }
}

