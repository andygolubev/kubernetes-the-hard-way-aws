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
      "sudo mkdir -p /usr/local/bin/",
      "sudo mkdir -p /var/lib/kubelet",
      "sudo chown ubuntu:ubuntu /var/lib/kubelet",
      "sudo mkdir -p /var/lib/kube-proxy",
      "sudo chown ubuntu:ubuntu /var/lib/kube-proxy",
      "sudo mkdir -p /var/lib/kubernetes",
      "sudo mkdir -p /var/run/kubernetes",
      "sudo mkdir -p /etc/containerd/",
      "sudo chown ubuntu:ubuntu /etc/containerd/",
      "mkdir -p /tmp/services"]
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

  provisioner "file" { 
    sources = ["/tmp/kthw-certs/config.toml"]
    destination = "/etc/containerd/"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/kubelet-config.yaml"]
    destination = "/var/lib/kubelet/kubelet-config.yaml"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/kube-proxy-config.yaml"]
    destination = "/var/lib/kube-proxy/kube-proxy-config.yaml"
  }


  provisioner "file" {
    sources     = ["/tmp/kthw-certs/containerd.service",
      "/tmp/kthw-certs/kubelet.service",
      "/tmp/kthw-certs/kube-proxy.service"]
    destination = "/tmp/services/"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/services/* /etc/systemd/system/"]
  }

  provisioner "shell" { // replace
    inline = [
      "sudo cp /etc/kubernetes/certs/working-node-0-key.pem /var/lib/kubelet/",
      "sudo cp /etc/kubernetes/certs/working-node-0.pem /var/lib/kubelet/",
      "sudo cp /etc/kubernetes/certs/ca.pem /var/lib/kubernetes/",
      "sudo cp /etc/kubernetes/config/working-node-0.kubeconfig /var/lib/kubelet/kubeconfig",
      "sudo cp /etc/kubernetes/config/kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig"
    ]
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
      "tar -xvf containerd-1.6.24-linux-amd64.tar.gz",
      "sudo mv /tmp/containerd-files/bin/* /bin/",
      "sudo rm -rf /tmp/containerd-files/"
    ]
  } 

  provisioner "shell" { 
    inline = [
      "sudo systemctl daemon-reload",
      "sudo systemctl enable containerd kubelet kube-proxy",
      "sudo systemctl start containerd kubelet kube-proxy",
      "sudo systemctl status containerd kubelet kube-proxy"
    ]
  } 

  provisioner "shell" { 
    inline = [
      "sudo sysctl net.ipv4.conf.all.forwarding=1",
      "echo 'net.ipv4.conf.all.forwarding=1' | sudo tee -a /etc/sysctl.conf",
      "echo '#!/bin/sh' | sudo tee -a /etc/init.d/mountcgroup.sh",
      "echo 'mkdir /sys/fs/cgroup/systemd' | sudo tee -a /etc/init.d/mountcgroup.sh",
      "echo 'mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd' | sudo tee -a /etc/init.d/mountcgroup.sh",
      "echo 'systemctl restart kubelet.service' | sudo tee -a /etc/init.d/mountcgroup.sh",
      "echo 'started' | sudo tee -a /home/ubuntu/mount.log",
      "sudo chmod +x /etc/init.d/mountcgroup.sh",
      "sudo update-rc.d mountcgroup.sh defaults",
      "sudo systemctl stop apparmor",
      "sudo systemctl disable apparmor"
    ]
  } 

  post-processor "manifest" { //replace
    output     = "manifest-working-node-0.json"
    strip_path = true
  }

}

