data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/*ubuntu-jammy-22.04-${var.arch}-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  owners      = ["099720109477"]
  most_recent = true
  region      = var.region
}

source "amazon-ebs" "ubuntu-kubernetes-the-hard-way" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-control-plane-1-{{timestamp}}"

  ssh_username = "ubuntu"
}