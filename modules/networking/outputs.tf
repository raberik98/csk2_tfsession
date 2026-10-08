output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpc" {
  value = aws_vpc.this
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "all_subnets" {
  value = merge(aws_subnet.public_subnets, aws_subnet.private_subnets)
}

output "NAT" {
  value = aws_nat_gateway.this[0]
}