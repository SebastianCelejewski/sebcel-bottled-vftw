resource "aws_ssm_parameter" "mapbox_public_access_token" {
  name = "/sebcel-bottled-vftw/${var.environment}/mapbox/public_access_token"
  type = "String"
  value = "CHANGE_ME"
  tags = merge(
    local.tags,
    {
      component = "frontend"
    }
  )

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}