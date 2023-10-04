# Public routes

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.kubernetes-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubernetes-igw.id
  }

  tags = {
    Name = "public routes"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet-0.id
  route_table_id = aws_route_table.public-rt.id
}


# Private routes

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.kubernetes-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.kubernetes-nat.id
  }

  tags = {
    Name = "private routes"
  }
}

resource "aws_route_table_association" "private-rt-association-0" {
  subnet_id      = aws_subnet.private-subnet-0.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-rt-association-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-rt-association-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}