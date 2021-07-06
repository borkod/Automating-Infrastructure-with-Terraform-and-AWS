resource "aws_codecommit_repository" "live-project-code-commit" {
  repository_name = "liveProjectCodeCommit"
  description     = "LiveProject App Repository"
  
  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}