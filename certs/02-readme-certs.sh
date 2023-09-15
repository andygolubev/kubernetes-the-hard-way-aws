# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# Now that you have provisioned a certificate authority for the Kubernetes cluster, you are ready to begin generating certificates. The first set of certificates you will need to generate consists of the client certificates used by various Kubernetes components. In this lesson, we will generate the following client certificates: admin , kubelet (one for each worker node), kubecontroller-manager , kube-proxy , and kube-scheduler . After completing this lesson, you will have the client certificate files which you will need later to set up the cluster.

# Here are the commands used in the demo. The command blocks surrounded by curly braces can be entered as a single command:

cd /tmp/kthw-certs



# Admin Client certificate:

{

cat > admin-csr.json << EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
admin-csr.json | cfssljson -bare admin

}

# Kubelet Client certificates. Be sure to enter your actual cloud server values for all four of the variables at the top:

WORKER0_HOST=working-node-00
WORKER0_IP=172.20.0.8
WORKER1_HOST=working-node-10
WORKER1_IP=172.20.16.8
WORKER2_HOST=working-node-20
WORKER2_IP=172.20.32.8

{
cat > ${WORKER0_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER0_HOST}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${WORKER0_IP},${WORKER0_HOST} \
  -profile=kubernetes \
  ${WORKER0_HOST}-csr.json | cfssljson -bare ${WORKER0_HOST}

cat > ${WORKER1_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER1_HOST}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${WORKER1_IP},${WORKER1_HOST} \
  -profile=kubernetes \
  ${WORKER1_HOST}-csr.json | cfssljson -bare ${WORKER1_HOST}


cat > ${WORKER2_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER2_HOST}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${WORKER2_IP},${WORKER2_HOST} \
  -profile=kubernetes \
  ${WORKER2_HOST}-csr.json | cfssljson -bare ${WORKER2_HOST}

}



# Controller Manager Client certificate:

{

cat > kube-controller-manager-csr.json << EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}

# Kube Proxy Client certificate:

{

cat > kube-proxy-csr.json << EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

}

# Kube Scheduler Client Certificate:

{

cat > kube-scheduler-csr.json << EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

}