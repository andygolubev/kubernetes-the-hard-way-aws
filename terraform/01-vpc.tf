# 172.20.0.0/16 (us-west-2)

resource "aws_vpc" "kubernetes-vpc" {
  cidr_block = "172.20.0.0/16"

  tags = {
    Name = "KubernetesVPC"
  }

}

resource "aws_internet_gateway" "kubernetes-igw" {
  vpc_id = aws_vpc.kubernetes-vpc.id

  tags = {
    Name = "Kubernetes-IGW"
  }
}

