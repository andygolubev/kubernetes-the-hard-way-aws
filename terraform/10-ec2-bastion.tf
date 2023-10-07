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


  user_data   = <<-EOF
            #!/bin/bash
            kubectl apply --kubeconfig /home/ubuntu/.kube/config -f /home/ubuntu/manifest/clusterrole.yaml
            kubectl apply --kubeconfig /home/ubuntu/.kube/config -f /home/ubuntu/manifest/clusterrolebinding.yaml
            kubectl apply --kubeconfig /home/ubuntu/.kube/config -f /home/ubuntu/manifest/weave-daemonset-k8s.yaml
            kubectl apply --kubeconfig /home/ubuntu/.kube/config -f /home/ubuntu/manifest/coredns.yaml
            EOF

  tags = {
    Name = "Bastion Host"
  }

  depends_on = [ aws_instance.control-plane-0, aws_instance.control-plane-1, aws_instance.control-plane-2, ]
  
}








