resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "MyVPC-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnet_count + 1)
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name        = "Private Subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "InternetGateway-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Public-route-table-${var.environment}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public-subnet-rt" {
  count          = var.public_subnet_count
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id

}

#Private subnet configuration

resource "aws_route_table" "private-rt" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Private-route-table-${count.index + 1}-${var.environment}"
  }
}

resource "aws_route" "private" {
  count                  = var.private_subnet_count
  route_table_id         = aws_route_table.private-rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id

}

resource "aws_route_table_association" "private-subnet-rt" {
  count          = var.private_subnet_count
  route_table_id = aws_route_table.private-rt[count.index].id
  subnet_id      = aws_subnet.private_subnet[count.index].id

}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.private_subnet_count
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "Nat-Gateway-${count.index + 1}"
  }

  depends_on = [aws_eip.eip, aws_internet_gateway.my_igw]

}

resource "aws_eip" "eip" {
  count  = var.private_subnet_count
  domain = "vpc"

  tags = {
    Name = "EIP-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.my_igw]

}