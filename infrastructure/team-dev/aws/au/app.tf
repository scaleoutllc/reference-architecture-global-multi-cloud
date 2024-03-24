data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "app.js"
  output_path = "lambda_function.zip"
}

resource "aws_iam_role" "hello-world" {
  name               = "${local.name}-hello-world"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "hello-world" {
  filename         = "lambda_function.zip"
  function_name    = "hello-world-${local.name}"
  role             = aws_iam_role.hello-world.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs18.x"
}

resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.test.function_name
  authorization_type = "NONE"
}
