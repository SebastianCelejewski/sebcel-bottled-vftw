resource "aws_s3_bucket" "analytics" {
  bucket = "sebcel-bottled-vftw-analytics-bucket-${var.environment}"
  tags = {
    Name = "sebcel-bottled-vftw-analytics-bucket-${var.environment}"
    component = "analytics"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id
  rule {
    id = "delete-old-analytics-events"
    status = "Enabled"
    filter {}
    expiration {
      days = 30
    }
  }
}

resource "aws_iam_role" "analytics_function" {
  name = "sebcel-bottled-vftw-analytics-function-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role = aws_iam_role.analytics_function.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "analytics_s3" {
  name = "sebcel-bottled-vftw-analytics-s3-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.analytics.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "analytics_s3" {
  role = aws_iam_role.analytics_function.name
  policy_arn = aws_iam_policy.analytics_s3.arn
}

resource "aws_lambda_function" "analytics" {
  function_name = "sebcel-bottled-vftw-analytics-${var.environment}"
  role = aws_iam_role.analytics_function.arn
  runtime = "nodejs22.x"
  handler = "index.handler"
  filename = data.archive_file.analytics_function.output_path
  source_code_hash = data.archive_file.analytics_function.output_base64sha256
  
  environment {
    variables = {
      ANALYTICS_BUCKET = aws_s3_bucket.analytics.bucket
    }
  }

  tags = {
    Name = "sebcel-bottled-vftw-analytics-${var.environment}"
    component = "analytics"
  }
}

data "archive_file" "analytics_function" {
  type = "zip"
  source_file = "${path.module}/function/index.js"
  output_path = "${path.module}/function/analytics.zip"
}

resource "aws_apigatewayv2_api" "analytics" {
  name = "sebcel-bottled-vftw-analytics-api-${var.environment}"

  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = [
      "content-type"
    ]

    allow_methods = [
      "POST"
    ]

    allow_origins = [
      "*"
    ]
  }

  tags = {
    Name = "sebcel-bottled-vftw-analytics-api-${var.environment}"
    component = "analytics"
  }
}

resource "aws_apigatewayv2_integration" "analytics" {
  api_id = aws_apigatewayv2_api.analytics.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.analytics.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "analytics" {
  api_id = aws_apigatewayv2_api.analytics.id
  route_key = "POST /analytics"
  target = "integrations/${aws_apigatewayv2_integration.analytics.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.analytics.id
  name = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.analytics.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.analytics.execution_arn}/*/*"
}