Example:

module "lb" {
  source = "../EthanBegalkaTerraformModuleLibrary/lb"

  resource_prefix = "jenkins"
  subnets         = module.vpc.public_subnet_ids
  security_groups = [aws_security_group.eb_jenkins_lb_sg.id]
  vpc_id          = module.vpc.vpc_id
  target_id       = aws_instance.eb_jenkins_instance.id
  certificate_arn = data.aws_acm_certificate.eb_certificate.arn

}