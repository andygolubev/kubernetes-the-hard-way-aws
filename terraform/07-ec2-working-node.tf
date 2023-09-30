## k8s-working-node-0

data "aws_ami" "k8s-k8s-working-node-0-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-k8s-working-node-0*"]
  }
}

resource "aws_instance" "k8s-working-node-0" {
  ami           = data.aws_ami.k8s-k8s-working-node-0-ami.id
  instance_type = var.instance_type_working_node

  key_name      = aws_key_pair.bastion-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-7.id
    device_index         = 0
  }

  tags = {
    Name = "k8s-working-node-0"
  }

}