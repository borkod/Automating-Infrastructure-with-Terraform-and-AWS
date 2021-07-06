resource "random_string" "prefix" {
  	length 			= 5
  	special 		= false
}

resource "aws_s3_bucket" "codecommit-s3" {
  bucket = join("-", [lower(replace(random_string.prefix.result, "[^a-zA-z0-9]", "x")), "liveprojects3"])
  acl    = "private"
  force_destroy 	= true

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}