# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# Kube-proxy is an important component of each Kubernetes worker node. It is responsible for providing network 
# routing to support Kubernetes networking components. In this lesson, we will configure our kube-proxy systemd 
# service. Since this is the last of the three worker node services that we need to configure, we will also go 
# ahead and start all of our worker node services once we're done. Finally, we will complete some steps to verify 
# that our cluster is set up properly and functioning as expected so far. After completing this lesson, you 
# should have two Kubernetes worker nodes up and running, and they should be able to successfully register 
# themselves with the cluster.

# You can configure the kube-proxy service like so. Run these commands on both worker nodes:

cd /tmp/kthw-certs


# Create the kube-proxy config file:

# cat << EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
cat > kube-proxy-config.yaml << EOF
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "10.200.0.0/16"
EOF

# Create the kube-proxy unit file:

# cat << EOF | sudo tee /etc/systemd/system/kube-proxy.service
cat > kube-proxy.service << EOF
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

