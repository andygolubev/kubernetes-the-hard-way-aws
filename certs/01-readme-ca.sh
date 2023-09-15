# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# In order to generate the certificates needed by Kubernetes, you must first provision a certificate authority. This lesson will guide you through the process of provisioning a new certificate authority for your Kubernetes cluster. After completing this lesson, you should have a certificate authority, which consists of two files: ca-key.pem and ca.pem.

# Here are the commands used in the demo:

mkdir -p /tmp/kthw-certs
cd /tmp/kthw-certs

curl -s -L -o /tmp/kthw-certs/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64

curl -s -L -o /tmp/kthw-certs/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

curl -s -L -o /tmp/kthw-certs/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64

chmod +x /tmp/kthw-certs/cfssl*
PATH=/tmp/kthw-certs:$PATH

# Use this command to generate the certificate authority. Include the opening and closing curly braces to run this entire block as a single command.

{

cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json << EOF
{
  "CN": "KubernetesTheHardWay",
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

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

}