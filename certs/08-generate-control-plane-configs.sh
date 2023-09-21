# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# You can configure the Kubernetes API server like so:

cd /tmp/kthw-certs

{

CONTROLLER0_IP=172.20.0.5
CONTROLLER1_IP=172.20.16.5
CONTROLLER2_IP=172.20.32.5

INTERNAL_IP=172.20.0.5

# Generate the kube-apiserver unit file for  systemd :

cat >  kube-apiserver.service-0 << EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=/etc/kubernetes/certs/ca.pem \\
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --enable-swagger-ui=true \\
  --etcd-cafile=/etc/kubernetes/certs/ca.pem \\
  --etcd-certfile=/etc/kubernetes/certs/kubernetes.pem \\
  --etcd-keyfile=/etc/kubernetes/certs/kubernetes-key.pem \\
  --etcd-servers=https://$CONTROLLER0_IP:2379,https://$CONTROLLER1_IP:2379,https://$CONTROLLER2_IP:2379 \\
  --event-ttl=1h \\
  --experimental-encryption-provider-config=/etc/kubernetes/config/encryption-config.yaml \\
  --kubelet-certificate-authority=/etc/kubernetes/certs/ca.pem \\
  --kubelet-client-certificate=/etc/kubernetes/certs/kubernetes.pem \\
  --kubelet-client-key=/etc/kubernetes/certs/kubernetes-key.pem \\
  --kubelet-https=true \\
  --runtime-config=api/all \\
  --service-account-key-file=/etc/kubernetes/certs/service-account.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --tls-cert-file=/etc/kubernetes/certs/kubernetes.pem \\
  --tls-private-key-file=/etc/kubernetes/certs/kubernetes-key.pem \\
  --v=2 \\
  --kubelet-preferred-address-types=InternalIP,InternalDNS,Hostname,ExternalIP,ExternalDNS
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

INTERNAL_IP=172.20.16.5

# Generate the kube-apiserver unit file for  systemd :

cat >  kube-apiserver.service-1 << EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=/etc/kubernetes/certs/ca.pem \\
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --enable-swagger-ui=true \\
  --etcd-cafile=/etc/kubernetes/certs/ca.pem \\
  --etcd-certfile=/etc/kubernetes/certs/kubernetes.pem \\
  --etcd-keyfile=/etc/kubernetes/certs/kubernetes-key.pem \\
  --etcd-servers=https://$CONTROLLER0_IP:2379,https://$CONTROLLER1_IP:2379,https://$CONTROLLER2_IP:2379 \\
  --event-ttl=1h \\
  --experimental-encryption-provider-config=/etc/kubernetes/config/encryption-config.yaml \\
  --kubelet-certificate-authority=/etc/kubernetes/certs/ca.pem \\
  --kubelet-client-certificate=/etc/kubernetes/certs/kubernetes.pem \\
  --kubelet-client-key=/etc/kubernetes/certs/kubernetes-key.pem \\
  --kubelet-https=true \\
  --runtime-config=api/all \\
  --service-account-key-file=/etc/kubernetes/certs/service-account.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --tls-cert-file=/etc/kubernetes/certs/kubernetes.pem \\
  --tls-private-key-file=/etc/kubernetes/certs/kubernetes-key.pem \\
  --v=2 \\
  --kubelet-preferred-address-types=InternalIP,InternalDNS,Hostname,ExternalIP,ExternalDNS
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

INTERNAL_IP=172.20.32.5

# Generate the kube-apiserver unit file for  systemd :

cat >  kube-apiserver.service-2 << EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=/etc/kubernetes/certs/ca.pem \\
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --enable-swagger-ui=true \\
  --etcd-cafile=/etc/kubernetes/certs/ca.pem \\
  --etcd-certfile=/etc/kubernetes/certs/kubernetes.pem \\
  --etcd-keyfile=/etc/kubernetes/certs/kubernetes-key.pem \\
  --etcd-servers=https://$CONTROLLER0_IP:2379,https://$CONTROLLER1_IP:2379,https://$CONTROLLER2_IP:2379 \\
  --event-ttl=1h \\
  --experimental-encryption-provider-config=/etc/kubernetes/config/encryption-config.yaml \\
  --kubelet-certificate-authority=/etc/kubernetes/certs/ca.pem \\
  --kubelet-client-certificate=/etc/kubernetes/certs/kubernetes.pem \\
  --kubelet-client-key=/etc/kubernetes/certs/kubernetes-key.pem \\
  --kubelet-https=true \\
  --runtime-config=api/all \\
  --service-account-key-file=/etc/kubernetes/certs/service-account.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --tls-cert-file=/etc/kubernetes/certs/kubernetes.pem \\
  --tls-private-key-file=/etc/kubernetes/certs/kubernetes-key.pem \\
  --v=2 \\
  --kubelet-preferred-address-types=InternalIP,InternalDNS,Hostname,ExternalIP,ExternalDNS
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



# generate control-manager config


# Generate the kube-controller-manager systemd unit file:

cat >  kube-controller-manager.service << EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-controller-manager \\
  --address=0.0.0.0 \\
  --cluster-cidr=10.200.0.0/16 \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/etc/kubernetes/certs/ca.pem \\
  --cluster-signing-key-file=/etc/kubernetes/certs/ca-key.pem \\
  --kubeconfig=/etc/kubernetes/config/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --root-ca-file=/etc/kubernetes/certs/ca.pem \\
  --service-account-private-key-file=/etc/kubernetes/certs/service-account-key.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


# Generate kube-scheduler config

cat >  kube-scheduler.yaml << EOF
apiVersion: componentconfig/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/etc/kubernetes/config/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

# Create the kube-scheduler systemd unit file:

cat >  kube-scheduler.service << EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --config=/etc/kubernetes/config/kube-scheduler.yaml \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

}