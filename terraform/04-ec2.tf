data "aws_ami" "k8s-control-plane-1-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-control-plane-1*"]
  }
}

resource "aws_instance" "test" {
  ami             = data.aws_ami.k8s-control-plane-1-ami.id
  instance_type   = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-4.id
    device_index         = 0
  }

  tags = {
    Name = "test ec2"
  }

}


resource "aws_instance" "bastion" {
  subnet_id                   = aws_subnet.public-subnet-0.id
  ami                         = "ami-03f65b8614a860c29"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.public.name]
  associate_public_ip_address = true

  tags = {
    Name = "test ec2 public"
  }

}