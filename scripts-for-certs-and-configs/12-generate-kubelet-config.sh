# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# Set a HOSTNAME environment variable that will be used to generate your config files. 
# Make sure you set the HOSTNAME appropriately for each worker node:

cd /tmp/kthw-certs

HOSTNAME=working-node-0

# Create the kubelet config file:

#cat << EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
cat > kubelet-config.yaml << EOF
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
EOF

# Create the kubelet unit file:

#cat << EOF | sudo tee /etc/systemd/system/kubelet.service
cat > kubelet.service << EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --register-node=true \\
  --v=2 \\
  --hostname-override=${HOSTNAME}
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF