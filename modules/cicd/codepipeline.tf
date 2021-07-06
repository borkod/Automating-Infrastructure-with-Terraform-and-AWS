resource "aws_codepipeline" "live-project-code-pipeline" {
  name                                      = "live-project-code-pipeline"
  role_arn                                  = aws_iam_role.codePipelineServiceRole.arn

  artifact_store {
    location                                = aws_s3_bucket.codecommit-s3.bucket
    type                                    = "S3"
  }

  stage {
    name                                    = "Source"

    # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-CodeCommit.html#action-reference-CodeCommit-config
    action {
      name                                  = "Source"
      category                              = "Source"
      owner                                 = "AWS"
      provider                              = "CodeCommit"
      version                               = "1"
      output_artifacts                      = ["sourceArtifact"]

      configuration = {
        RepositoryName                      = aws_codecommit_repository.live-project-code-commit.repository_name
        BranchName                          = "master"
      }
    }
  }

  stage {
    name                                  = "Build"

    action {
      name                                = "Build"
      category                            = "Build"
      owner                               = "AWS"
      provider                            = "CodeBuild"
      version                             = "1"
      input_artifacts                     = ["sourceArtifact"]
      output_artifacts                    = ["buildArtifact"]

      configuration = {
        ProjectName                       = aws_codebuild_project.live-project-codebuild.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["buildArtifact"]

      configuration = {
        ApplicationName                = aws_codedeploy_app.liveproject-deploy.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.liveproject-DeploymentGroup.deployment_group_name
        TaskDefinitionTemplateArtifact = "buildArtifact"
        AppSpecTemplateArtifact        = "buildArtifact"
      }
    }
  }
}