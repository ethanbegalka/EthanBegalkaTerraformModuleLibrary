data "aws_route53_zone" "zone" {
  name         = var.route53_hosted_zone_name
  private_zone = false
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Access identity for CloudFront distribution"
}

resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = "${var.resource_prefix}_origin_access_control"
  description                       = "${var.resource_prefix}_origin_access_control"
  origin_access_control_origin_type = var.origin_access_control_origin_type
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

module "s3_bucket" {
  source = "../s3_bucket"

  bucket_name = "${var.resource_prefix}-distribution-logs-bucket"
  acl = "private"
  object_ownership = "BucketOwnerPreferred"
}

data "aws_cloudfront_cache_policy" "managed_caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "managed_forward_all_and_headers" {
  name = "Managed-AllViewerAndCloudFrontHeaders-2022-06"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = var.origin_domain_name
    # origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_id = var.origin_id
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols     = [
        "SSLv3",
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  logging_config {
   bucket = module.s3_bucket.bucket_domain_name
   prefix = var.resource_prefix 
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.resource_prefix} distribution"
  default_root_object = "index"

  # web_acl_id = aws_wafv2_web_acl.web_acl.arn
  web_acl_id = var.web_acl_arn

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = var.origin_id
    # Using the CachingDisabled managed policy ID:
    cache_policy_id  = data.aws_cloudfront_cache_policy.managed_caching_disabled.id
    origin_request_policy_id  = data.aws_cloudfront_origin_request_policy.managed_forward_all_and_headers.id
    viewer_protocol_policy = "redirect-to-https"
  }

  # default_cache_behavior {
  #   allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
  #   cached_methods  = ["GET", "HEAD"]
  #   target_origin_id = var.origin_id

  #   forwarded_values {
  #     query_string = false
  #     # headers      = ["Host"]
  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   viewer_protocol_policy = "redirect-to-https"
  #   min_ttl                = 0
  #   default_ttl            = 0
  #   max_ttl                = 0
  # }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }
}

resource "aws_route53_record" "record_to_distribution" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.apex_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_record_to_distribution" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www.${var.apex_domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}