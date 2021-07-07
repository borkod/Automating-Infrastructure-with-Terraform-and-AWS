resource "random_string" "prefix" {
  	length 			= 5
  	special 		= false
}

resource "aws_s3_bucket" "live-project-prod-build" {
  bucket 			    = join("-", [lower(replace(random_string.prefix.result, "[^a-zA-z0-9]", "x")), "live-project-source-bucket"])
  force_destroy 	= true
  acl           = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  replication_configuration {
    role = aws_iam_role.s3ReplicationRole.arn

    rules {
      status = "Enabled"
      destination {
        bucket = var.destBucketArn
        replica_kms_key_id = var.destKmsArn
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = "true"
        }
      }
    }
  }
}