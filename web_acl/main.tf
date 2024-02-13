data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  my_ip = "${chomp(data.http.myip.response_body)}/32"
}


resource "aws_wafv2_ip_set" "ip_set" {
  name               = "${var.resource_prefix}_ip_set"
  description        = "${var.resource_prefix}_ip_set"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = [local.my_ip]
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = var.name
  description = "Web ACL that allows only my IP address"
  scope       = "CLOUDFRONT"
  default_action {
    block {}
  }

  rule {
    name     = "allow-my-ip"
    priority = 1

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }

    action {
      allow {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-waf-logs-${var.name}-friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "aws-waf-logs-${var.name}-friendly-rule-metric-name2"
    sampled_requests_enabled   = false
  }
}

resource "aws_cloudwatch_log_group" "waf_log_group" {
  name = "aws-waf-logs-${var.name}-log-group"
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_config" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn
}