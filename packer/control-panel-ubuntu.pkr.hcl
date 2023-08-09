packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}



source "amazon-ebs" "ubuntu" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type

  ami_name = "k8s-instance-${var.arch}-{{timestamp}}"


  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-${var.arch}-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}