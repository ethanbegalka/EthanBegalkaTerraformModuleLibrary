output "subnet_ids" {
  value = [for subnet in aws_subnet.subnet : subnet.id]
}

output "public_subnet_ids" {
  value = [for key, subnet in var.subnets : aws_subnet.subnet[key].id if subnet.public]
}

output "vpc_id"{
    value = aws_vpc.vpc.id
}