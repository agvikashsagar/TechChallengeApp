provider "aws" {
    region = var.aws_region
    #access_key = ""
    #secret_key = ""
}

resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_public_1" {
  cidr_block        = var.aws_cidr_block_subnet_public_1
  availability_zone = "${var.aws_region}a"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "subnet_public_2" {
  cidr_block        = var.aws_cidr_block_subnet_public_2
  availability_zone = "${var.aws_region}b"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "Public-Subnet-2"
  }
}

resource "aws_subnet" "subnet_public_3" {
  cidr_block        = var.aws_cidr_block_subnet_public_3
  availability_zone = "${var.aws_region}c"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "Public-Subnet-3"
  }
}

resource "aws_subnet" "subnet_private_1" {
  cidr_block        = var.aws_cidr_block_subnet_private_1
  availability_zone = "${var.aws_region}a"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "subnet_private_2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}b"
  cidr_block        = var.aws_cidr_block_subnet_private_2
  tags = {
    Name = "Private-Subnet-2"
  }
}

resource "aws_subnet" "subnet_private_3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}c"
  cidr_block        = var.aws_cidr_block_subnet_private_3
  tags = {
    Name = "Private-Subnet-3"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "postgres-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_public_1.id,aws_subnet.subnet_public_2.id,aws_subnet.subnet_public_3.id]

  tags = {
    Name = "db-subnet"
  }
}



resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.subnet_public_1.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.subnet_public_2.id
}

resource "aws_route_table_association" "public-route-3-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.subnet_public_3.id
}


resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.subnet_private_1.id
}

resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.subnet_private_2.id
}

resource "aws_route_table_association" "private-route-3-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.subnet_private_3.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "EIP"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.subnet_public_1.id

  tags = {
    Name = "NAT-GW"
  }

  depends_on = [aws_eip.elastic-ip-for-nat-gw]
}

resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}