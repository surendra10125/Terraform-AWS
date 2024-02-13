output "vpc_id" {
  value       = aws_vpc.vpc_name.id
  description = "id of vpc"
}

output "vpc_nane" {
  value       = var.vpc_name
  description = "id of vpc"
}

output "vpc_cidr_block"{
  value = aws_vpc.vpc_name.cidr_block
}

output "nat_gateway_id"{
   value = aws_nat_gateway.nat_gateway.id
 }

output "nat_gateway_name"{
  value = aws_nat_gateway.nat_gateway.tags.Name
}
output "internet_gateway_id" {
  value = aws_internet_gateway.ig.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_name" {
  value = var.public_subnet_name
}

output "private_subnet_id" {
  value = aws_subnet.subnets.*.id
}

output "private_subnet_names" {
  value = var.subnet_names
}