resource "aws_s3_bucket" "website" {
  bucket = var.website_bucket_name
  tags = merge(
    local.tags,
    {
      Name = var.website_bucket_name
      component = "website"
    }
    
  )
}

resource "aws_s3_bucket" "photos" {
  bucket = var.photos_bucket_name
  tags = merge(
    local.tags,
    {
      Name = var.photos_bucket_name
      component = "photos"
    }
  )
}

resource "aws_cloudfront_origin_access_control" "website" {
  name = "sebcel-bottled-vftw-website-oac-${var.environment}"
  description = "OAC for website bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_origin_access_control" "photos" {
  name = "sebcel-bottled-vftw-photos-oac-${var.environment}"
  description = "OAC for photos bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"
  comment = "sebcel-bottled-vftw-${var.environment}"
  aliases = var.aliases
  web_acl_id = var.web_acl_id
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id = "websiteS3"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  origin {
    domain_name = aws_s3_bucket.photos.bucket_regional_domain_name
    origin_id = "photosS3"
    origin_access_control_id = aws_cloudfront_origin_access_control.photos.id
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    target_origin_id = "websiteS3"
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  ordered_cache_behavior {
    path_pattern = "/photos/*"

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    target_origin_id = "photosS3"
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  price_class = "PriceClass_All"

  tags = merge(
    local.tags,
    {
      Name = "sebcel-bottled-vftw-website-distribution-${var.environment}"
      component = "website"
    }
  )
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.frontend.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "photos" {
  bucket = aws_s3_bucket.photos.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.photos.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.frontend.arn
          }
        }
      }
    ]
  })
}