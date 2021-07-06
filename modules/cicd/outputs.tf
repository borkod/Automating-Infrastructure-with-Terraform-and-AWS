output "repository_id" {
    value = aws_codecommit_repository.live-project-code-commit.repository_id 
    description = "The generated repository id"
}

output "codbuild_arn" {
  value = aws_codebuild_project.live-project-codebuild.arn
}
