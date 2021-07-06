module "code_commit" {
    source          = "../modules/cicd/"
    repo_name       = "webserver"
    ListenerArn     = data.aws_lb_listener.app-layer-Listener.arn
    TG1             = "app-layer-TG-green"
    TG2             = "app-layer-TG-blue"
    ecsTaskRoleArn  = data.aws_iam_role.ecsServiceRole.arn
    ecsServiceRoleArn = data.aws_iam_role.ecsTaskRole.arn
    ecsServiceArn = data.aws_ecs_service.app_ecs.arn
}

data "aws_lb" "app-layer-ALB" {
  name = "app-layer-ALB"
}

data "aws_lb_listener" "app-layer-Listener" {
  load_balancer_arn = data.aws_lb.app-layer-ALB.arn
  port              = 80
}

data "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole"
}

data "aws_iam_role" "ecsTaskRole" {
  name = "ecsTaskRole"
}

data "aws_ecs_service" "app_ecs" {
  service_name            = "liveproject-ecs"
  cluster_arn = data.aws_ecs_cluster.app_ecs_cluster.arn
}

data "aws_ecs_cluster" "app_ecs_cluster" {
  cluster_name = "live-project-ecs-cluster"
}