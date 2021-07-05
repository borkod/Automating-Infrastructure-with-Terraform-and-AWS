module "bastion_ec2_cluster" {
  source                 = "../modules/ec2/"

  name                   = "ec2-bastion"
  instance_count         = 3

  ami                    = var.bastion-ami
  instance_type          = var.bastion-type
  key_name               = var.bastion-key
  vpc_security_group_ids = [aws_security_group.allow_ssh_bastion.id]
  subnet_ids              = [
                                for subnet in data.aws_subnet_ids.public-subnets.ids:
                                tostring(subnet)
                            ]
  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}

