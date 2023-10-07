source "amazon-ebs" "ubuntu-kubernetes-the-hard-way-bastion-host" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-bastion-host-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  name = "k8s-bastion-host"
  sources = [
    "source.amazon-ebs.ubuntu-kubernetes-the-hard-way-bastion-host"
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
    inline = [
      "mkdir -p /home/ubuntu/manifest/",
    "mkdir -p /home/ubuntu/.kube/"]
  }

  provisioner "file" {
    sources     = ["/tmp/kthw-certs/hosts"]
    destination = "/tmp/"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/bastion-key",
    "/tmp/kthw-certs/bastion-key.pub"]
    destination = "/home/ubuntu/.ssh/"
  }

  provisioner "file" {
    sources     = ["/tmp/kthw-certs/bastion.kubeconfig"]
    destination = "/home/ubuntu/.kube/config"
  }

  provisioner "file" {
    sources = [
      "/tmp/kthw-certs/clusterrole.yaml",
      "/tmp/kthw-certs/clusterrolebinding.yaml",
      "/tmp/kthw-certs/weave-daemonset-k8s.yaml",
      "/tmp/kthw-certs/coredns.yaml"
    ]
    destination = "/home/ubuntu/manifest/"
  }


  provisioner "shell" {
    inline = ["cat /tmp/hosts | sudo tee -a /etc/hosts"]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /tmp/k8s-server-components",
      "cd /tmp/k8s-server-components",
      "wget --quiet https://cdn.dl.k8s.io/release/v1.28.2/kubernetes-server-linux-amd64.tar.gz",
      "tar -xvf kubernetes-server-linux-amd64.tar.gz",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kubectl /usr/local/bin/",
      "rm -rf /tmp/k8s-server-components"
    ]
  }

  post-processor "manifest" {
    output     = "manifest-bastion-host.json"
    strip_path = true
  }

}

