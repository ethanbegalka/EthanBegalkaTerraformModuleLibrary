Example:

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