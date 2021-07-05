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


data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}

data "aws_ecr_repository" "webserver-ecr" {
  name = "webserver"
}