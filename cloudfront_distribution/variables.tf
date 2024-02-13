variable "resource_prefix" {
    type = string
}

variable "route53_hosted_zone_name" {
    type = string
}

variable "web_acl_arn" {
    type = string
}

variable "origin_id" {
    type = string
}

variable "origin_domain_name" {
    type = string
}

variable "acm_certificate_arn"{
    type = string
}

variable "origin_access_control_origin_type" {
    type = string
}

variable "alias" {
    type = string
}
