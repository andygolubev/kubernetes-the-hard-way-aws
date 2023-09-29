# From A Cloud Guru course "Kubernetes the Hard Way" https://www.pluralsight.com/cloud-guru/courses/kubernetes-the-hard-way


# Containerd is the container runtime used to run containers managed by Kubernetes in this course. In this lesson, 
# we will configure a systemd service for containerd on both of our worker node servers. This containerd service will 
# be used to run containerd as a component of each worker node. After completing this lesson, you should have 
# a containerd configured to run as a systemd service on both workers.

# You can configure the containerd service like so. Run these commands on both worker nodes:



cd /tmp/kthw-certs

# Create the containerd config.toml:
cat > config.toml << EOF
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
    [plugins.cri.containerd.untrusted_workload_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runsc"
      runtime_root = "/run/containerd/runsc"
EOF

# Create the containerd unit file:

cat > containerd.service << EOF
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF