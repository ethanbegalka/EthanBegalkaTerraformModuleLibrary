Example:

module "cloudfront_distribution" {
  source = "../EthanBegalkaTerraformModuleLibrary/cloudfront_distribution"

  resource_prefix = "jenkins"

  route53_hosted_zone_name          = "yourdomain.com"
  web_acl_arn                       = module.web_acl.web_acl_arn
  origin_id                         = "ALB-${module.lb.lb_id}"
  origin_domain_name                = module.lb.lb_dns_name
  origin_access_control_origin_type = "s3"
  acm_certificate_arn               = data.aws_acm_certificate.eb_certificate.arn
  alias                             = "subdomain.yourdomain.com""
}