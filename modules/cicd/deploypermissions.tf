resource "aws_iam_role" "codeDeployServiceRole" {
    name = "codeDeployServiceRole"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.assume_by_codedeploy.json
}

resource "aws_iam_role_policy_attachment" "codeDeploy-role-attachment" {
    role = aws_iam_role.codeDeployServiceRole.name
    policy_arn = aws_iam_policy.codeDeployPolicy.arn
}

resource "aws_iam_policy" "codeDeployPolicy" {
  name   = "codeDeployPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.deploymentPermissionsDocument.json
}


data "aws_iam_policy_document" "assume_by_codedeploy" {
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
                type = "Service"
                identifiers = ["codedeploy.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "deploymentPermissionsDocument" {
    statement {
        sid    = "AllowECS"
        effect = "Allow"

        actions = [
            "ecs:CreateTaskSet",
            "ecs:DeleteTaskSet",
            "ecs:DescribeServices",
            "ecs:UpdateServicePrimaryTaskSet",
            "ecs:RegisterTaskDefinition"
        ]

        resources = ["*"]
    }
    
    statement {
        sid    = "AllowLoadBalancing"
        effect = "Allow"

        actions = [
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:ModifyRule"
        ]

        resources = ["*"]
    }

    statement {
        sid    = "AllowS3"
        effect = "Allow"

        actions = ["s3:*"]

        resources = [
            "${var.sourceS3BucketArn}",
            "${var.sourceS3BucketArn}/*"
        ]
    }

    statement {
        sid    = "AllowCodeDeploy"
        effect = "Allow"

        actions = [
            "codedeploy:CreateDeployment",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:GetApplication",
            "codedeploy:GetApplicationRevision",
            "codedeploy:RegisterApplicationRevision"
        ]

        resources = ["*"]
    }
    
    statement {
        sid    = "AllowPassRole"
        effect = "Allow"

        actions = ["iam:PassRole"]

        resources = [
            var.ecsServiceRoleArn,
            var.ecsTaskRoleArn,
            var.ecsServiceArn,
            aws_iam_role.codeDeployServiceRole.arn
        ]
    }
}