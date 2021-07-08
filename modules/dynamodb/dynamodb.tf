resource "aws_dynamodb_table" "live-project-dynamodb-table" {
  name           = "life-project-db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "ID"
  stream_enabled    = true
  stream_view_type  = "NEW_IMAGE"

  attribute {
    name = "ID"
    type = "N"
  }

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }

  provisioner "local-exec" {
    command = "python3 ./resources/populate_db.py life-project-db ./resources/koffee_luv_drink_menu.csv ${var.destRegion} ${var.destBucketName} ${var.backupFileName}"
  }
}