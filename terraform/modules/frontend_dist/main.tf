# Create an Origin Access Identity for CloudFront
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.environment}-${var.app_name} frontend"
}

# S3 bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/${var.html_directory}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.frontend_distribution.arn
          }
        }
      }
    ]
  })
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "S3-${var.environment}-${var.app_name}-frontend"
    origin_path = "/${var.html_directory}"

    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object
  price_class         = var.price_class

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = "S3-${var.environment}-${var.app_name}-frontend"

    forwarded_values {
      query_string = true # Forward query strings for React routing
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = true
  }

  # React app needs these error responses to handle client-side routing
  # Handle 403 errors (when a file doesn't exist in S3)
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/${var.default_root_object}"
    error_caching_min_ttl = 10
  }

  # Handle 404 errors
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/${var.default_root_object}"
    error_caching_min_ttl = 10
  }

  # Geo restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
    # For custom domain:
    # acm_certificate_arn = "arn:aws:acm:us-east-1:account-id:certificate/certificate-id"
    # ssl_support_method = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2021"
  }

  # Cache behavior for static assets - optional but recommended for React apps
  # This provides longer caching for files in the static directory
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${var.environment}-${var.app_name}-frontend"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400    # 1 day
    max_ttl                = 31536000 # 1 year
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  tags = {
    Name        = "${var.environment}-${var.app_name}-frontend-distribution"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Create Origin Access Control (OAC) - newer and more secure than OAI
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.environment}-${var.app_name}-oac"
  description                       = "Origin Access Control for ${var.environment}-${var.app_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
