source "amazon-ebs" "ubuntu-control-panel" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-control-node-${var.arch}-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  # name = "k8s-control-panel-builder"
  sources = [
    "source.amazon-ebs.ubuntu-control-panel"
  ]
}