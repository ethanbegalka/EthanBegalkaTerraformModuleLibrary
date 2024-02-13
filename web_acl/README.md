Example:

module "web_acl" {
  source = "../EthanBegalkaTerraformModuleLibrary/web_acl"

  name            = "jenkins-web-acl"
  resource_prefix = "jenkins"
}