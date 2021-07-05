resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "live-project-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}

resource "aws_ecs_service" "app_ecs" {
  name            = "liveproject-ecs"
  cluster         = aws_ecs_cluster.app_ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.webserver.family}:${aws_ecs_task_definition.webserver.revision}" 
  launch_type     = "EC2"
  desired_count   = 1
  iam_role        = aws_iam_role.ecsServiceRole.arn
  depends_on      = [aws_iam_role_policy.executionServiceRolePolicy, aws_lb.app-layer-ALB, aws_lb_target_group.app-layer-TG]

  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app-layer-TG.arn
    container_name   = "webserver"
    container_port   = 8080
  }

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}