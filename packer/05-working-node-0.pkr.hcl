source "amazon-ebs" "ubuntu-kubernetes-the-hard-way-working-node-0" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-working-node-0-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  name = "k8s-working-node-0"
  sources = [
    "source.amazon-ebs.ubuntu-kubernetes-the-hard-way-working-node-0"
  ]

  provisioner "shell" {
    inline = ["echo WAIT FOR CLOUD_INIT FINISH",
      "cloud-init status --wait"]
  }

  provisioner "shell" {
    inline = [
      "echo set debconf to Noninteractive", 
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections" ]
  }

  provisioner "shell" {
    inline = ["echo current user $(whoami)",
      "sudo mkdir -p /etc/kubernetes/certs",
      "sudo chown ubuntu:ubuntu /etc/kubernetes/certs",
      "sudo mkdir -p /etc/kubernetes/config",
    "sudo chown ubuntu:ubuntu /etc/kubernetes/config"]
  }


  provisioner "file" { // replace
    sources = ["/tmp/kthw-certs/ca.pem",
      "/tmp/kthw-certs/working-node-0-key.pem",
    "/tmp/kthw-certs/working-node-0.pem"] 
    destination = "/etc/kubernetes/certs/"
  }

  provisioner "file" { //replace
    sources = ["/tmp/kthw-certs/working-node-0.kubeconfig",
    "/tmp/kthw-certs/kube-proxy.kubeconfig"]
    destination = "/etc/kubernetes/config/"
  }

  provisioner "shell" {
    inline = ["ls -la /etc/kubernetes/certs /etc/kubernetes/config"]
  }

  post-processor "manifest" { //replace
    output     = "manifest-working-node-0.json"
    strip_path = true
  }

}

