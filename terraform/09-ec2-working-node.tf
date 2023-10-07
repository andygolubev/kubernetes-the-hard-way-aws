## k8s-working-node-0

data "aws_ami" "k8s-working-node-0-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-working-node-0*"]
  }
}

resource "aws_instance" "k8s-working-node-0" {
  ami           = data.aws_ami.k8s-working-node-0-ami.id
  instance_type = var.instance_type_working_node

  key_name = aws_key_pair.bastion-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-0-eip-172-20-0-7.id
    device_index         = 0
  }

  user_data = <<-EOF
            #!/bin/bash
            mkdir /sys/fs/cgroup/systemd
            mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
            systemctl restart kubelet.service
            EOF

  tags = {
    Name = "k8s-working-node-0"
  }

}

## k8s-working-node-1

data "aws_ami" "k8s-working-node-1-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-working-node-1*"]
  }
}

resource "aws_instance" "k8s-working-node-1" {
  ami           = data.aws_ami.k8s-working-node-1-ami.id
  instance_type = var.instance_type_working_node

  key_name = aws_key_pair.bastion-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-1-eip-172-20-16-7.id
    device_index         = 0
  }

  user_data = <<-EOF
            #!/bin/bash
            mkdir /sys/fs/cgroup/systemd
            mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
            systemctl restart kubelet.service
            EOF

  tags = {
    Name = "k8s-working-node-1"
  }

}

## k8s-working-node-2

data "aws_ami" "k8s-working-node-2-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-working-node-2*"]
  }
}

resource "aws_instance" "k8s-working-node-2" {
  ami           = data.aws_ami.k8s-working-node-2-ami.id
  instance_type = var.instance_type_working_node

  key_name = aws_key_pair.bastion-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.private-subnet-2-eip-172-20-32-7.id
    device_index         = 0
  }

  user_data = <<-EOF
            #!/bin/bash
            mkdir /sys/fs/cgroup/systemd
            mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
            systemctl restart kubelet.service
            EOF

  tags = {
    Name = "k8s-working-node-2"
  }

}