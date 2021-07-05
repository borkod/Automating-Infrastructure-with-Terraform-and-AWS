resource "aws_ecs_task_definition" "webserver" {
  family = "webserver"
  network_mode          = "bridge"
  requires_compatibilities        = ["EC2"]
  memory                = 256
  cpu                   = 128
  container_definitions = jsonencode([
    {
      name      = "webserver"
      image     = "webserver/webserver:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])

  execution_role_arn    = aws_iam_role.ecsServiceRole.arn
  task_role_arn         = aws_iam_role.ecsTaskRole.arn

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}