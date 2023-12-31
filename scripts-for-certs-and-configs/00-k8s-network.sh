# 172.20.0.0/16

# 172.20.0.0/20 west-2a (private subnet)

# 172.20.0.4 - load-balancer-internal
# 172.20.0.5 - control-plane-0
# 172.20.0.7 - working-node-0

# ----------------------------------------

# 172.20.16.0/20 west-2b (private subnet)

# 172.20.16.5 - control-plane-1
# 172.20.16.7 - working-node-1

# ----------------------------------------

# 172.20.32.0/20 west-2c (private subnet)

# 172.20.32.5 - control-plane-2
# 172.20.32.7 - working-node-2

# ----------------------------------------

# 172.20.48.0/20 west-2a (public subnet)

# 172.20.X.X - bastion host

mkdir -p /tmp/kthw-certs
cd /tmp/kthw-certs

cat > hosts << EOF

172.20.0.4 load-balancer-internal
172.20.0.5 control-plane-0
172.20.0.7 working-node-0
172.20.16.5 control-plane-1
172.20.16.7 working-node-1
172.20.32.5 control-plane-2
172.20.32.7 working-node-2

EOF