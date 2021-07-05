resource "aws_ecr_repository" "webserver-ecr" {
  name                 = "webserver"
  image_tag_mutability = "MUTABLE"

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}