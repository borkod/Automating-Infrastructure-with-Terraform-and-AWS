resource "aws_ecr_repository" "foo" {
  name                 = "webserver"
  image_tag_mutability = "MUTABLE"

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}