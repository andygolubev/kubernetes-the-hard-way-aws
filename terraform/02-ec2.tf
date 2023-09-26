data "aws_ami" "k8s-control-plane-1-ami" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["k8s-control-plane-1"]
  }
}

resource "aws_instance" "foo" {
  ami           = data.aws_ami.k8s-control-plane-1-ami.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-4.id
    device_index         = 0
  }

    tags = {
    Name = "test ec2"
  }

}