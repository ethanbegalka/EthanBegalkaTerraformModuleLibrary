# EthanBegalkaTerraformModuleLibrary

Within some of my personal projects, here are terraform modules I've created and have used in my own private projects.

## Examples:

```
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

module "lb" {
  source = "../EthanBegalkaTerraformModuleLibrary/lb"

  resource_prefix = "jenkins"
  subnets         = module.vpc.public_subnet_ids
  security_groups = [aws_security_group.eb_jenkins_lb_sg.id]
  vpc_id          = module.vpc.vpc_id
  target_id       = aws_instance.eb_jenkins_instance.id
  certificate_arn = data.aws_acm_certificate.eb_certificate.arn

}

module "s3_bucket" {
  source = "../EthanBegalkaTerraformModuleLibrary/s3_bucket"

  bucket_name = "bucketname"
  acl = "private"
  object_ownership = "BucketOwnerPreferred"
}

module "vpc" {
  source = "../EthanBegalkaTerraformModuleLibrary/vpc"

  resource_prefix = "jenkins"

  vpc_cidr_block = "10.20.0.0/18"

  subnets = {
    eb_jenkins_private_subnet1 = {
      cidr_block        = "10.20.20.0/26"
      availability_zone = data.aws_availability_zones.available.names[0]
      name              = "eb_jenkins_private_subnet1"
      public            = false
    },
    eb_jenkins_public_subnet1 = {
      cidr_block        = "10.20.20.64/26"
      availability_zone = data.aws_availability_zones.available.names[0]
      name              = "eb_jenkins_public_subnet1"
      public            = true
    },
    eb_jenkins_public_subnet2 = {
      cidr_block        = "10.20.20.128/26"
      availability_zone = data.aws_availability_zones.available.names[1]
      name              = "eb_jenkins_public_subnet2"
      public            = true
    }
  }
}

module "web_acl" {
  source = "../EthanBegalkaTerraformModuleLibrary/web_acl"

  name            = "jenkins-web-acl"
  resource_prefix = "jenkins"
}
```
