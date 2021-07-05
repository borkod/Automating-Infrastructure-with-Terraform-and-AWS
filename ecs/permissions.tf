resource "aws_iam_role" "ecsServiceRole" {
    name = "ecsServiceRole"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.assume_by_ecs.json
}

resource "aws_iam_role" "ecsTaskRole" {
    name = "ecsTaskRole"
    path = "/"
    # assume_role_policy = data.aws_iam_policy_document.assume_by_ecs_tasks.json
    assume_role_policy = data.aws_iam_policy_document.assume_by_ecs.json
}

data "aws_iam_policy_document" "assume_by_ecs" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
                type = "Service"
                identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "assume_by_ecs_tasks" {
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
                type = "Service"
                identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy" "executionServiceRolePolicy" {
  role   = aws_iam_role.ecsServiceRole.name
  policy = data.aws_iam_policy_document.ecs_execution_role.json
}

resource "aws_iam_role_policy" "taskRolePolicy" {
  role   = aws_iam_role.ecsTaskRole.name
  policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role_policy_attachment" "ecs-role-attachment" {
    role = aws_iam_role.ecsServiceRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs-role-attachment2" {
    role = aws_iam_role.ecsServiceRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-attachment" {
    role = aws_iam_role.ecsTaskRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_execution_role" {
    statement {
        sid    = "AllowECRPull"
        effect = "Allow"

        actions = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability"
        ]

        resources = [data.aws_ecr_repository.webserver-ecr.arn]
    }

    statement {
        sid    = "AllowECRAuth"
        effect = "Allow"

        actions = ["ecr:GetAuthorizationToken"]

        resources = ["*"]
    }

    statement {
        sid    = "AllowDescribeHealth"
        effect = "Allow"

        actions = ["elasticloadbalancing:DescribeTargetHealth"]

        resources = ["*"]
    }

    statement {
        sid    = "AllowLogging"
        effect = "Allow"

        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]

        resources = ["*"]
    }
}

data "aws_iam_policy_document" "ecs_task_role" {
    statement {
        sid    = "AllowEcrReadAccess"
        effect = "Allow"

        actions = ["ecs:DescribeClusters"]

        resources = [aws_ecs_cluster.app_ecs_cluster.arn]
    }
}