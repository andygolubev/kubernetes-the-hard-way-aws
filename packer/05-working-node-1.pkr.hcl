source "amazon-ebs" "ubuntu-kubernetes-the-hard-way" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-working-node-1-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  name = "k8s-working-node-1"
  sources = [
    "source.amazon-ebs.ubuntu-kubernetes-the-hard-way"
  ]

  provisioner "shell" {
    inline = ["echo current user $(whoami)",
              "sudo mkdir -p /etc/kubernetes/certs",
              "sudo chown ubuntu:ubuntu /etc/kubernetes/certs"]
  }

  provisioner "file" {
    sources      = ["/tmp/kthw-certs/ca-key.pem", 
                    "/tmp/kthw-certs/kubernetes-key.pem", 
                    "/tmp/kthw-certs/kubernetes.pem", 
                    "/tmp/kthw-certs/service-account-key.pem", 
                    "/tmp/kthw-certs/service-account.pem" ]
    destination = "/etc/kubernetes/certs/"
  }

  provisioner "shell" {
    inline = ["ls -la /etc/kubernetes/certs"]
  }

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
    manifest_file = "../puppet/configure-working-node-1.pp"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }

  // jq -r '.builds[0].artifact_id|split(":")[1]' ./manifest.json 



}

