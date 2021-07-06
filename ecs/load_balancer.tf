resource "aws_lb" "app-layer-ALB" {
  name               = "app-layer-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.AlbSG.id]
  subnets            = data.aws_subnet_ids.app-layer-subnets.ids

  enable_deletion_protection = false
  #depends_on = [aws_internet_gateway.MyIGW]
}

resource "aws_lb_listener" "app-layer-Listener" {
  load_balancer_arn = aws_lb.app-layer-ALB.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-layer-TG.arn
  }
}

locals {
  target_groups = [
    "green",
    "blue",
  ]
}

resource "aws_lb_target_group" "app-layer-TG" {
  count = length(local.target_groups)
  name = "app-layer-TG-${element(local.target_groups, count.index)}"
  port              = 8080
  protocol          = "HTTP"
  vpc_id            = data.aws_vpc.my-vpc.id
  target_type       = "instance"
  health_check {
    protocol        = "HTTP"
    path            = "/KoffeeLuv" 
  }
  
}
