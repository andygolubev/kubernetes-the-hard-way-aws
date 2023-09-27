## control-plane-0

data "aws_ami" "k8s-control-plane-0-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-control-plane-0*"]
  }
}

resource "aws_instance" "control-plane-0" {
  ami           = data.aws_ami.k8s-control-plane-0-ami.id
  instance_type = var.instance_type_control_plane

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-5.id
    device_index         = 0
  }

  tags = {
    Name = "control-plane-0"
  }

}

## control-plane-1

data "aws_ami" "k8s-control-plane-1-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-control-plane-1*"]
  }
}

resource "aws_instance" "control-plane-1" {
  ami           = data.aws_ami.k8s-control-plane-0-ami.id
  instance_type = var.instance_type_control_plane

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-1-eip-172-20-16-5.id
    device_index         = 0
  }

  tags = {
    Name = "control-plane-1"
  }

}


## control-plane-2

data "aws_ami" "k8s-control-plane-2-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-control-plane-2*"]
  }
}

resource "aws_instance" "control-plane-2" {
  ami           = data.aws_ami.k8s-control-plane-0-ami.id
  instance_type = var.instance_type_control_plane

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-2-eip-172-20-32-5.id
    device_index         = 0
  }

  tags = {
    Name = "control-plane-2"
  }

}