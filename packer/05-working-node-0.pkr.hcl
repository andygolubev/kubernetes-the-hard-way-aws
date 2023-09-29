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
      "sudo chown ubuntu:ubuntu /etc/kubernetes/config",
      "sudo mkdir -p /opt/cni/bin/",
      "sudo mkdir -p /usr/local/bin/"]
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

  provisioner "shell" {
    inline = ["echo current user $(whoami)",
      "sudo apt update",
      "sudo apt install -y socat conntrack ipset"]
  }

  provisioner "shell" { // kubectl kube-proxy kubelet
    inline = [
      "mkdir -p /tmp/k8s-server-components",
      "cd /tmp/k8s-server-components",
      "wget --quiet https://cdn.dl.k8s.io/release/v1.28.2/kubernetes-server-linux-amd64.tar.gz",
      "tar -xvf kubernetes-server-linux-amd64.tar.gz",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kube-proxy /usr/local/bin/",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kubelet /usr/local/bin/",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kubectl /usr/local/bin/",
      "sudo rm -rf /tmp/k8s-server-components"
    ]
  }  

  provisioner "shell" { // cni-plugins
    inline = [
      "mkdir -p /tmp/cni-plugins/",
      "cd /tmp/cni-plugins",
      "wget --quiet https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz",
      "sudo tar -xvf cni-plugins-linux-amd64-v1.3.0.tgz -C /opt/cni/bin/",
      "sudo rm -rf /tmp/cni-plugins"
    ]
  }  

  provisioner "shell" { //runc runsc
    inline = [
      "mkdir -p /tmp/runc-files/",
      "cd /tmp/runc-files/",
      "wget --quiet https://storage.googleapis.com/gvisor/releases/release/latest/x86_64/runsc",
      "wget --quiet https://github.com/opencontainers/runc/releases/download/v1.1.9/runc.amd64",
      "mv runc.amd64 runc",
      "chmod +x /tmp/runc-files/runsc /tmp/runc-files/runc",
      "sudo mv /tmp/runc-files/runsc /tmp/runc-files/runc /usr/local/bin/",
      "sudo rm -rf /tmp/runc-files/"
    ]
  }  

  provisioner "shell" { // crictl
    inline = [
      "mkdir -p /tmp/crictl-files/",
      "cd /tmp/crictl-files/",
      "wget --quiet https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz",
      "sudo tar -xvf crictl-v1.28.0-linux-amd64.tar.gz -C /usr/local/bin/",
      "sudo rm -rf /tmp/crictl-files/"
    ]
  } 

  provisioner "shell" { // containerd
    inline = [
      "mkdir -p /tmp/containerd-files/",
      "cd /tmp/containerd-files/",
      "wget --quiet https://github.com/containerd/containerd/releases/download/v1.6.24/containerd-1.6.24-linux-amd64.tar.gz",
      "sudo tar -xvf containerd-1.6.24-linux-amd64.tar.gz -C /",
      "sudo rm -rf /tmp/containerd-files/"
    ]
  } 


  post-processor "manifest" { //replace
    output     = "manifest-working-node-0.json"
    strip_path = true
  }

}

