resource "aws_lambda_event_source_mapping" "lambda_event_maps_dynamodb" {
 event_source_arn  = aws_dynamodb_table.live-project-dynamodb-table.stream_arn
  function_name     = aws_lambda_function.streaming_lambda.arn
  starting_position = "LATEST"
}

data "archive_file" "streaming_lambda_zip" {
    type          = "zip"
    source_file   = "../modules/dynamodb/resources/streaming.py"
    output_path   = "../modules/dynamodb/resources/streaming_lambda_function.zip"
}

resource "aws_lambda_function" "streaming_lambda" {
  function_name    = "streaming_lambda"
  role             = aws_iam_role.iam_role_for_lambda.arn
  handler          = "streaming.handler"
  filename         = data.archive_file.streaming_lambda_zip.output_path
  source_code_hash = data.archive_file.streaming_lambda_zip.output_base64sha256
  runtime          = "python3.7"
  timeout          = "60"

  environment {
      variables = {
          destRegion        = var.destRegion
          destBucket        = var.destBucketName
          backupFile        = var.backupFileName
      }
  }
}