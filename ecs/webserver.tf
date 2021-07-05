resource "aws_launch_configuration" "webserver_conf" {
  name_prefix   = "liveproject-webserver-"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = var.ec2-type
  security_groups = [aws_security_group.EcsSG.id]
  associate_public_ip_address = false
  key_name = var.ec2-key
  user_data = "${file("user_data.sh")}"
    
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                 = "liveproject-asg"
  launch_configuration = aws_launch_configuration.webserver_conf.name
  min_size             = 1
  max_size             = 3 
  vpc_zone_identifier = data.aws_subnet_ids.app-layer-subnets.ids
  health_check_type = "ELB"

  lifecycle {
    create_before_destroy = true
  }

}