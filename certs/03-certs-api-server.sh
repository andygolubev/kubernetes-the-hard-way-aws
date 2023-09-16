# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# We have generated all of the the client certificates our Kubernetes cluster will need, but we also need a server certificate 
# for the Kubernetes API. In this lesson, we will generate one, signed with all of the hostnames and IPs that may be used later 
# in order to access the Kubernetes API. After completing this lesson, you will have a Kubernetes API server certificate in the 
# form of two files called kubernetes-key.pem  and kubernetes.pem .

# Here are the commands used in the demo. Be sure to replace all the placeholder values in CERT_HOSTNAME with their real values 
# from your cloud servers:

cd /tmp/kthw-certs


# add all control planes, load balancers
CERT_HOSTNAME=10.32.0.1,127.0.0.1,localhost,kubernetes.default,172.20.0.5,control-plane-0,172.20.16.5,control-plane-1,172.20.0.7,load-balancer-0

{

cat > kubernetes-csr.json << EOF
{

  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IL",
      "L": "Tel Aviv",
      "O": "Kubernetes The Hard Way",
      "OU": "Operations",
      "ST": "Tel Aviv District"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${CERT_HOSTNAME} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

}