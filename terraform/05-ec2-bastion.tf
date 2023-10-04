# data "aws_ami" "bastion" {
#   most_recent = true
#   owners      = ["099720109477"]

#     filter {
#         name   = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#     }

#     filter {
#         name = "virtualization-type"
#         values = ["hvm"]
#     }

# }

data "aws_ami" "k8s-bastion-host-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-bastion-host*"]
  }
}

resource "aws_instance" "bastion" {
  subnet_id                   = aws_subnet.public-subnet-0.id
  ami                         = data.aws_ami.k8s-bastion-host-ami.id
  instance_type               = var.instance_type_bastion
  security_groups             = [ aws_security_group.public.id, ]
  associate_public_ip_address = true

  key_name      = aws_key_pair.bastion-key.key_name


  # user_data   = <<-EOF
  #           #!/bin/bash
  #           kubectl apply -f /home/ubuntu/manifest/clusterrole.yaml
  #           kubectl apply -f /home/ubuntu/manifest/clusterrolebinding.yaml
  #           kubectl apply -f /home/ubuntu/manifest/weave-daemonset-k8s.yaml
  #           EOF


  # Connect with AWS Resoeces
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("/tmp/kthw-certs/bastion-key")
  }


  # Remote Provisioner for User Data
  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f /home/ubuntu/manifest/clusterrole.yaml",
      "kubectl apply -f /home/ubuntu/manifest/clusterrolebinding.yaml",
      "kubectl apply -f /home/ubuntu/manifest/weave-daemonset-k8s.yaml"
    ]
  }

  tags = {
    Name = "Bastion Host"
  }

  depends_on = [ aws_instance.control-plane-0, aws_instance.control-plane-1, aws_instance.control-plane-2, ]
  
}








