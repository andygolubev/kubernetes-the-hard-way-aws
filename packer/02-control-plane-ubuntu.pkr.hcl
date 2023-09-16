source "amazon-ebs" "ubuntu-control-plane" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-control-plane-${var.arch}-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  # name = "k8s-control-plane-builder"
  sources = [
    "source.amazon-ebs.ubuntu-control-plane"
  ]

  provisioner "shell" {
    inline = ["sudo mkdir --mode=770 -p /etc/kubernetes/certs", "ls -la /etc/kubernetes/certs"]
  }

  # provisioner "file" {
  #   sources      = ["/tmp/kthw-certs/ca-key.pem", 
  #                   "/tmp/kthw-certs/kubernetes-key.pem", 
  #                   "/tmp/kthw-certs/kubernetes.pem", 
  #                   "/tmp/kthw-certs/service-account-key.pem", 
  #                   "/tmp/kthw-certs/service-account.pem" ]
  #   destination = "/etc/kubernetes/certs/"
  # }

  provisioner "shell" {
    inline = ["sudo apt -y update",
      "wget http://apt.puppet.com/puppet8-release-jammy.deb",
      "sudo dpkg -i puppet8-release-jammy.deb",
      "sudo apt -y update",
      "sudo apt -y install puppet-agent",
      "echo 'Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin' | sudo tee -a /etc/sudoers.d/extra",
      "bash"
    ]
  }

  provisioner "puppet-masterless" {
    manifest_file = "../puppet/configure-control-plane.pp"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }

  // jq -r '.builds[0].artifact_id|split(":")[1]' ./manifest.json 



}

