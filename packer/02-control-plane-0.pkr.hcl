source "amazon-ebs" "ubuntu-kubernetes-the-hard-way-control-plane-0" {

  profile       = "default"
  region        = var.region
  instance_type = var.instance_type
  source_ami    = data.amazon-ami.ubuntu.id

  ami_name = "k8s-control-plane-0-{{timestamp}}"

  ssh_username = "ubuntu"
}

build {
  name = "k8s-control-plane-0"
  sources = [
    "source.amazon-ebs.ubuntu-kubernetes-the-hard-way-control-plane-0"
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
      "sudo mkdir -p /etc/etcd",
      "sudo chown ubuntu:ubuntu /etc/etcd",
      "sudo mkdir -p /var/lib/etcd",
      "sudo chown ubuntu:ubuntu /var/lib/etcd",
      "mkdir -p /tmp/services"]
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/hosts",
      "/tmp/kthw-certs/kubernetes.default.svc.cluster.local"]
    destination = "/tmp/"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/ca-key.pem",
      "/tmp/kthw-certs/ca.pem",
      "/tmp/kthw-certs/kubernetes-key.pem",
      "/tmp/kthw-certs/kubernetes.pem",
      "/tmp/kthw-certs/service-account-key.pem",
    "/tmp/kthw-certs/service-account.pem"]
    destination = "/etc/kubernetes/certs/"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/ca.pem",
      "/tmp/kthw-certs/kubernetes-key.pem",
    "/tmp/kthw-certs/kubernetes.pem"]
    destination = "/etc/etcd/"
  }

  provisioner "file" {
    sources = ["/tmp/kthw-certs/admin.kubeconfig",
      "/tmp/kthw-certs/kube-controller-manager.kubeconfig",
      "/tmp/kthw-certs/kube-scheduler.kubeconfig",
      "/tmp/kthw-certs/encryption-config.yaml",
    "/tmp/kthw-certs/kube-scheduler.yaml"]
    destination = "/etc/kubernetes/config/"
  }

  provisioner "file" {
    sources     = ["/tmp/kthw-certs/etcd.service-0"] // replace
    destination = "/tmp/services/etcd.service"
  }

  provisioner "file" {
    sources     = ["/tmp/kthw-certs/kube-apiserver.service-0"] // replace
    destination = "/tmp/services/kube-apiserver.service"
  }

  provisioner "file" {
    sources     = ["/tmp/kthw-certs/kube-controller-manager.service",
      "/tmp/kthw-certs/kube-scheduler.service"]
    destination = "/tmp/services/"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/services/* /etc/systemd/system/"]
  }


  provisioner "shell" {
    inline = ["cat /tmp/hosts | sudo tee -a /etc/hosts"]
  }

  provisioner "shell" {
    inline = ["ls -la /etc/kubernetes/certs /etc/etcd /etc/kubernetes/config /etc/systemd/system/"]
  }

  # provisioner "shell" {
  #   inline = ["sudo apt -y update",
  #     "wget http://apt.puppet.com/puppet8-release-jammy.deb",
  #     "sudo dpkg -i puppet8-release-jammy.deb",
  #     "sudo apt -y update",
  #     "sudo apt -y install puppet-agent",
  #     "echo 'Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin' | sudo tee -a /etc/sudoers.d/extra",
  #     "bash"
  #   ]
  # }


  provisioner "shell" {
    inline = [
      "wget --quiet --https-only --timestamping https://github.com/etcd-io/etcd/releases/download/v3.4.27/etcd-v3.4.27-linux-amd64.tar.gz",
      "tar -xvf etcd-v3.4.27-linux-amd64.tar.gz",
      "sudo mv etcd-v3.4.27-linux-amd64/etcd* /usr/local/bin/"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo systemctl daemon-reload",
      "sudo systemctl enable etcd",
      "sudo systemctl start etcd",
      "sudo systemctl status etcd"
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /tmp/k8s-server-components",
      "cd /tmp/k8s-server-components",
      "wget --quiet https://cdn.dl.k8s.io/release/v1.28.2/kubernetes-server-linux-amd64.tar.gz",
      "tar -xvf kubernetes-server-linux-amd64.tar.gz",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kube-apiserver /usr/local/bin/",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kube-controller-manager /usr/local/bin/",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kube-scheduler /usr/local/bin/",
      "sudo mv /tmp/k8s-server-components/kubernetes/server/bin/kubectl /usr/local/bin/",
      "rm -rf /tmp/k8s-server-components"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo systemctl daemon-reload",
      "sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler",
      "sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler",
      "sudo systemctl status kube-apiserver kube-controller-manager kube-scheduler"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo apt update && sudo apt install -y nginx",
      "sudo mkdir -p /etc/nginx/sites-enabled/",
      "sudo mv /tmp/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/",
      "sudo systemctl enable nginx",
      "sudo systemctl restart nginx",
      "sudo systemctl status nginx"]
  }


  # provisioner "shell" {
  #   inline = ["kubectl get componentstatuses --kubeconfig /etc/kubernetes/config/admin.kubeconfig"]
  # }


# sudo ETCDCTL_API=3 etcdctl member list \
#   --endpoints=https://127.0.0.1:2379 \
#   --cacert=/etc/etcd/ca.pem \
#   --cert=/etc/etcd/kubernetes.pem \
#   --key=/etc/etcd/kubernetes-key.pem

  # provisioner "puppet-masterless" {
  #   manifest_file = "../puppet/configure-control-plane-0.pp"
  # }

  post-processor "manifest" {
    output     = "manifest-control-plane-0.json"
    strip_path = true
  }

  // jq -r '.builds[0].artifact_id|split(":")[1]' ./manifest.json 

}

