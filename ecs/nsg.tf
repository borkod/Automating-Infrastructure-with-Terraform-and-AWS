resource "aws_security_group" "EcsSG" {
    name        = "EcsSG"
    description = "Allow ssh"
    vpc_id      = data.aws_vpc.my-vpc.id
    
    tags = {
        Name = "EcsSG"
    }

    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "TCP"
        security_groups = [aws_security_group.allow_ssh_bastion.id]
    }

    ingress {
        from_port   = "32768"
        to_port     = "65535"
        protocol    = "TCP"
        security_groups = [aws_security_group.AlbSG.id]
    }

    ingress {
        from_port   = "80"
        to_port     = "80"
        protocol    = "TCP"
        security_groups = [aws_security_group.AlbSG.id]
    }

    ingress {
        from_port   = "443"
        to_port     = "443"
        protocol    = "TCP"
        security_groups = [aws_security_group.AlbSG.id]
    }

    ingress {
        from_port   = "8080"
        to_port     = "8080"
        protocol    = "TCP"
        security_groups = [aws_security_group.AlbSG.id]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_security_group" "AlbSG" {
    name        = "AlbSG"
    description = "Allow http"
    vpc_id      = data.aws_vpc.my-vpc.id
    
    tags = {
        Name = "AlbSG"
    }

    ingress {
        from_port   = "80"
        to_port     = "80"
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}