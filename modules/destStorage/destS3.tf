resource "random_string" "prefix" {
  	length 			= 5
  	special 		= false
}


resource "aws_s3_bucket" "live-project-destination-bucket" {
  bucket 			= join("-", [lower(replace(random_string.prefix.result, "[^a-zA-z0-9]", "x")), "live-project-dest-bucket"])
  force_destroy 	= true
  acl           = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.dest.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [aws_kms_key.dest]
}

resource "aws_kms_key" "dest" {
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "dest" {
  name          = "alias/dest"
  target_key_id = aws_kms_key.dest.key_id
}

# resource "aws_s3_bucket" "koffee-menu-backup" {
#   bucket 			= join("-", [lower(replace(random_string.prefix.result, "[^a-zA-z0-9]", "x")), "koffee-menu-backup"])
#   force_destroy 	= true
#   acl           = "private"

#   versioning {
#     enabled = true
#   }

#   lifecycle {
#     prevent_destroy = false
#   }

# }