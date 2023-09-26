
# 172.20.0.0/20 (private subnet)

# 172.20.0.4 - load-balancer-internal
# 172.20.0.5 - control-plane-0
# 172.20.0.7 - working-node-0


resource "aws_subnet" "private-subnet-0" {
  vpc_id            = aws_vpc.kubernetes-vpc.id
  cidr_block        = "172.20.0.0/20"
  availability_zone = var.availability_zone_names[0]

  tags = {
    Name = "private-subnet-0-${var.availability_zone_names[0]}"
  }
}

resource "aws_network_interface" "private-subnet-0-eip-172-20-0-4" {
  subnet_id   = aws_subnet.private-subnet-0.id
  private_ips = ["172.20.0.4"]

  tags = {
    Name = "private-subnet-0-eip-172-20-0-4"
  }
}

resource "aws_network_interface" "private-subnet-0-eip-172-20-0-5" {
  subnet_id   = aws_subnet.private-subnet-0.id
  private_ips = ["172.20.0.5"]

  tags = {
    Name = "private-subnet-0-eip-172-20-0-5"
  }
}

resource "aws_network_interface" "private-subnet-0-eip-172-20-0-7" {
  subnet_id   = aws_subnet.private-subnet-0.id
  private_ips = ["172.20.0.7"]

  tags = {
    Name = "private-subnet-0-eip-172-20-0-7"
  }
}


# 172.20.16.0/20 (private subnet)

# 172.20.16.5 - control-plane-1
# 172.20.16.7 - working-node-1



resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.kubernetes-vpc.id
  cidr_block        = "172.20.16.0/20"
  availability_zone = var.availability_zone_names[1]

  tags = {
    Name = "private-subnet-1-${var.availability_zone_names[1]}"
  }
}

resource "aws_network_interface" "private-subnet-1-eip-172-20-16-5" {
  subnet_id   = aws_subnet.private-subnet-1.id
  private_ips = ["172.20.16.5"]

  tags = {
    Name = "private-subnet-1-eip-172-20-16-5"
  }
}

resource "aws_network_interface" "private-subnet-1-eip-172-20-16-6" {
  subnet_id   = aws_subnet.private-subnet-1.id
  private_ips = ["172.20.16.6"]

  tags = {
    Name = "private-subnet-1-eip-172-20-16-6"
  }
}



# 172.20.32.0/20 (private subnet)

# 172.20.32.5 - control-plane-2
# 172.20.32.7 - working-node-2


resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.kubernetes-vpc.id
  cidr_block        = "172.20.32.0/20"
  availability_zone = var.availability_zone_names[2]

  tags = {
    Name = "private-subnet-2-${var.availability_zone_names[2]}"
  }
}

resource "aws_network_interface" "private-subnet-2-eip-172-20-32-5" {
  subnet_id   = aws_subnet.private-subnet-2.id
  private_ips = ["172.20.32.5"]

  tags = {
    Name = "private-subnet-2-eip-172-20-32-5"
  }
}

resource "aws_network_interface" "private-subnet-2-eip-172-20-32-6" {
  subnet_id   = aws_subnet.private-subnet-2.id
  private_ips = ["172.20.32.6"]

  tags = {
    Name = "private-subnet-2-eip-172-20-32-6"
  }
}



# 172.20.48.0/20 (public subnet)

# 172.20.48.4 - load-balancer-external



resource "aws_subnet" "public-subnet-0" {
  vpc_id            = aws_vpc.kubernetes-vpc.id
  cidr_block        = "172.20.48.0/20"
  availability_zone = var.availability_zone_names[0]

  tags = {
    Name = "public-subnet-0-${var.availability_zone_names[0]}"
  }
}

resource "aws_network_interface" "public-subnet-0-eip-172-20-48-4" {
  subnet_id   = aws_subnet.public-subnet-0.id
  private_ips = ["172.20.48.4"]

  tags = {
    Name = "public-subnet-0-eip-172-20-48-4"
  }
}
