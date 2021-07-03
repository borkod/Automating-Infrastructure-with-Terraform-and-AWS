data "aws_vpc" "my-vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}

data "aws_subnet_ids" "app-layer-subnets" {
  vpc_id = data.aws_vpc.my-vpc.id
  filter {
    name   = "cidr-block"
    values = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  }
}

data "aws_subnet_ids" "public-subnets" {
  vpc_id = data.aws_vpc.my-vpc.id
  filter {
    name   = "cidr-block"
    values = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  }
}

module "app_layer_ec2_cluster" {
  source                 = "../modules/ec2/"

  name                   = "ec2-app-layer"
  instance_count         = 3

  ami                    = var.app-layer-ami
  instance_type          = var.app-layer-type
  key_name               = var.app-layer-key
  vpc_security_group_ids = [aws_security_group.app_layer_allow_from_bastion.id]
  subnet_ids              = [
                                for subnet in data.aws_subnet_ids.app-layer-subnets.ids:
                                tostring(subnet)
                            ]
  associate_public_ip_address = false

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}

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

resource "aws_security_group" "allow_ssh_bastion" {
  name        = "allow_ssh_bastion"
  description = "Allow SSH inbound traffic to bastion hosts"
  vpc_id      = data.aws_vpc.my-vpc.id

  ingress {
    description      = "SSH from public"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_bastion"
  }
}

resource "aws_security_group" "app_layer_allow_from_bastion" {
  name        = "app_layer_allow_from_bastion"
  description = "Allow inbound traffic from bastion hosts to app layer"
  vpc_id      = data.aws_vpc.my-vpc.id

  ingress {
    description      = "App layer from bastion"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.allow_ssh_bastion.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app_layer_allow_from_bastion"
  }
}