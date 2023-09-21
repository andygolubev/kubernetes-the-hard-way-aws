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
    inline = ["echo current user $(whoami)",
      "sudo apt update",
      "sudo apt install -y nginx libnginx-mod-stream",
      "sudo systemctl enable nginx",
      "sudo mkdir -p /etc/nginx/tcpconf.d",
      "echo 'include /etc/nginx/tcpconf.d/*;' | sudo tee -a /etc/nginx/nginx.conf",]
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/kubernetes.conf",
      "/tmp/kthw-certs/hosts"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/kubernetes.conf /etc/nginx/tcpconf.d/"]
  }

  provisioner "shell" {
    inline = ["cat /tmp/hosts | sudo tee -a /etc/hosts",
      "sudo nginx -s reload"]
  }

  post-processor "manifest" {
    output     = "manifest-load-balancer-internal.json"
    strip_path = true
  }

  // jq -r '.builds[0].artifact_id|split(":")[1]' ./manifest.json 

}

