output "analytics_endpoint" {
  value = "${aws_apigatewayv2_api.analytics.api_endpoint}/analytics"
}

output "athena_database_name" {
  value = aws_athena_database.analytics.name
}

output "athena_workgroup_name" {
  value = aws_athena_workgroup.analytics.name
}