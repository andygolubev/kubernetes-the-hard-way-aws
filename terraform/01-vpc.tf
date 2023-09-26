# 172.20.0.0/16

# 172.20.0.0/20 west-2a (private subnet)

# 172.20.0.4 - load-balancer-internal
# 172.20.0.5 - control-plane-0
# 172.20.0.7 - working-node-0




# 172.20.16.0/20 west-2b (private subnet)

# 172.20.16.5 - control-plane-1
# 172.20.16.7 - working-node-1


# 172.20.32.0/20 west-2c (private subnet)

# 172.20.32.5 - control-plane-2
# 172.20.32.7 - working-node-2


# 172.20.48.0/20 west-2a (public subnet)

# 172.20.48.4 - load-balancer-external



resource "aws_vpc" "kubernetes-vpc" {
  cidr_block = "172.20.0.0/16"

  tags = {
    Name = "KubernetesVPC"
  }

}

resource "aws_subnet" "private-subnet-0" {
  vpc_id            = aws_vpc.kubernetes-vpc.id
  cidr_block        = "172.20.0.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private-subnet-0 west-2a"
  }
}

resource "aws_network_interface" "private-subnet-0-eip-172-20-0-4" {
  subnet_id   = aws_subnet.private-subnet-0
  private_ips = ["172.20.0.4"]

  tags = {
    Name = "private-subnet-0-eip-172-20-0-4"
  }
}








resource "aws_instance" "foo" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-4.id
    device_index         = 0
  }

    tags = {
    Name = "test ec2"
  }

}