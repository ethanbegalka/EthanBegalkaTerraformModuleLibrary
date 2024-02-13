variable "subnets" {
    type = list(string)
}

variable "security_groups" {
    type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "target_id" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "certificate_arn" {
  type = string
}