# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way


# Set up some environment variables for the lead balancer config file:

CONTROLLER0_IP=172.20.0.5
CONTROLLER1_IP=172.20.16.5
CONTROLLER2_IP=172.20.32.5

# Create the load balancer nginx config file:

cat > kubernetes.conf << EOF
stream {
    upstream kubernetes {
        server $CONTROLLER0_IP:6443;
        server $CONTROLLER1_IP:6443;
        server $CONTROLLER2_IP:6443;
    }

    server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}
EOF
