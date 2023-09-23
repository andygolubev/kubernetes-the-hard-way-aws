# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way

# In order to make use of Kubernetes' ability to encrypt sensitive data at rest, 
# you need to provide Kubernetes with an encrpytion key using a data encryption config 
# file. This lesson walks you through the process of creating a encryption key and storing 
# it in the necessary file, as well as showing how to copy that file to your Kubernetes 
# controllers. After completing this lesson, you should have a valid Kubernetes data 
# encryption config file, and there should be a copy of that file on each of your 
# Kubernetes controller servers.

# Here are the commands used in the demo.

# Generate the Kubernetes Data encrpytion config file containing the encrpytion key:

cd /tmp/kthw-certs

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml << EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

