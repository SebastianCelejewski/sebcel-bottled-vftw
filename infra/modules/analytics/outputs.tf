output "analytics_endpoint" {
  value = "${aws_apigatewayv2_api.analytics.api_endpoint}/analytics"
}