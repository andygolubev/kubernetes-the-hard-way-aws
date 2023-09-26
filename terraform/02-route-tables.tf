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