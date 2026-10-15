output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpc" {
  value = aws_vpc.this
}

output "vpc_name" {
  value = var.vpc_name
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "all_subnets" {
  value = local.all_subnets
}

output "all_subnets_list" {
  value = [ for key, sn in local.all_subnets: { name = key, val = sn } ]
}


output "NAT" {
  value = aws_nat_gateway.this[0]
}