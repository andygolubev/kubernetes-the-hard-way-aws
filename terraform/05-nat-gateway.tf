resource "aws_eip" "eip-nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "kubernetes-nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.public-subnet-0.id

  tags = {
    Name = "Kubernetes-NAT"
  }

  depends_on = [aws_internet_gateway.kubernetes-igw]
}