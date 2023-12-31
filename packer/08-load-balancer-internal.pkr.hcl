source "amazon-ebs" "ubuntu-kubernetes-the-hard-way-load-balancer-internal" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-load-balancer-internal-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  name = "k8s-load-balancer-internal"
  sources = [
    "source.amazon-ebs.ubuntu-kubernetes-the-hard-way-load-balancer-internal"
  ]

  provisioner "shell" {
    inline = ["echo WAIT FOR CLOUD_INIT FINISH",
    "cloud-init status --wait"]
  }

  provisioner "shell" {
    inline = [
      "echo set debconf to Noninteractive",
    "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections"]
  }


  provisioner "shell" {
    inline = ["echo current user $(whoami)",
      "sudo apt update",
      "sudo apt install -y nginx",
    "sudo systemctl enable nginx"]
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/nginx.conf",
    "/tmp/kthw-certs/hosts"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = ["sudo mv -f /tmp/nginx.conf /etc/nginx/nginx.conf",
    "sudo nginx -s reload"]
  }

  provisioner "shell" {
    inline = ["cat /tmp/hosts | sudo tee -a /etc/hosts"]
  }

  post-processor "manifest" {
    output     = "manifest-load-balancer-internal.json"
    strip_path = true
  }

}

