output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public-subnet-1_id" {
  value = aws_subnet.subnet_public_1.id
}

output "public-subnet-2_id" {
  value = aws_subnet.subnet_public_2.id
}

output "public-subnet-3_id" {
  value = aws_subnet.subnet_public_3.id
}

output "private-subnet-1_id" {
  value = aws_subnet.subnet_private_1.id
}

output "private-subnet-2_id" {
  value = aws_subnet.subnet_private_2.id
}

output "private-subnet-3_id" {
  value = aws_subnet.subnet_private_3.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.name
}

