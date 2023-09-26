resource "aws_security_group" "public" {
  name        = "public-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.kubernetes-vpc.id

  ingress {
    description      = "SSH from Internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Kube API server from Internet"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-public"
  }
}

resource "aws_security_group" "private" {
  name        = "private-sg"
  description = "Allow traffic from public sg"
  vpc_id      = aws_vpc.kubernetes-vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-private"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private-ingress-rule" {
  security_group_id = aws_security_group.private.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
  referenced_security_group_id = aws_security_group.public.id
}

