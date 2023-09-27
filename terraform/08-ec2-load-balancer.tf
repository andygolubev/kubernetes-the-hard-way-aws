## control-plane-0

data "aws_ami" "k8s-load-balancer-internal-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-load-balancer-internal-*"]
  }
}

resource "aws_instance" "k8s-load-balancer-internal" {
  ami           = data.aws_ami.k8s-load-balancer-internal-ami.id
  instance_type = var.instance_type_load_balancer

  key_name      = aws_key_pair.bastion-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-4.id
    device_index         = 0
  }

  tags = {
    Name = "load-balancer-internal"
  }

}
