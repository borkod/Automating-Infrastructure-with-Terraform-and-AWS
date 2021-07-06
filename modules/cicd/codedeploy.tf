resource "aws_codedeploy_app" "liveproject-deploy" {
  compute_platform = "ECS"
  name             = "liveproject-deploy"
}

resource "aws_codedeploy_deployment_config" "liveproject-DeploymentConfig" {
  deployment_config_name                    = "liveproject-DeploymentConfig"
  compute_platform                          = "ECS"

  traffic_routing_config {
    type = "AllAtOnce"
  }
}

resource "aws_codedeploy_deployment_group" "liveproject-DeploymentGroup" {
  app_name                                = aws_codedeploy_app.liveproject-deploy.name
  deployment_group_name                   = "liveproject-DeploymentGroup"
  deployment_config_name                  = aws_codedeploy_deployment_config.liveproject-DeploymentConfig.id
  service_role_arn                        = aws_iam_role.codeDeployServiceRole.arn

  ecs_service {
    cluster_name                          = var.ecsClusterName
    service_name                          = var.ecsServiceName
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout                   = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                              = "TERMINATE"
      termination_wait_time_in_minutes    = 5
    }
  }

  deployment_style {
    deployment_option                     = "WITH_TRAFFIC_CONTROL"
    deployment_type                       = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns                       = [var.ListenerArn]
      }

      target_group {
        name                                = var.TG1
      }

      target_group {
        name                                = var.TG2
      }
    }
  }
}