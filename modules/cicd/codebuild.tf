resource "aws_codebuild_project" "live-project-codebuild" {
  name          = "live-project"
  description   = "LiveProject Code Build project"
  build_timeout = "5"
  service_role  = aws_iam_role.code-build-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "${var.region}"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "${var.repo_name}"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name                                  = "AWS_ACCOUNT_ID"
      value                                 = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name                                  = "TASK_DEFINITION"
      value                                 = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/webserver"
    }

    environment_variable {
      name                                  = "FAMILY"
      value                                 = "webserver"
    }

    environment_variable {
      name                                  = "CONTAINER_NAME"
      value                                 = "webserver"
    }
    
  }

  source {
    type = "CODEPIPELINE"
  }

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}