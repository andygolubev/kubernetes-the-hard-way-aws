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
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections" ]
  }
  

  provisioner "file" {
    sources = ["/tmp/kthw-certs/hosts"]
    destination = "/tmp/"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/bastion-key",
    "/tmp/kthw-certs/bastion-key.pub"]
    destination = "/home/ubuntu/.ssh/"
  }

  provisioner "shell" {
    inline = ["cat /tmp/hosts | sudo tee -a /etc/hosts"]
  }

  post-processor "manifest" {
    output     = "manifest-bastion-host.json"
    strip_path = true
  }

}

