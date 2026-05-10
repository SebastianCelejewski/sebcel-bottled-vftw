data "aws_ssm_parameter" "mapbox_public_access_token" {
  name = "/sebcel-bottled-vftw/${var.environment}/mapbox/public_access_token"
}