
cd /tmp/kthw-certs

cat > coredns.yaml << EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: coredns
  namespace: kube-system
  labels:
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"

---
# Source: coredns/templates/clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: coredns
  labels:
    app.kubernetes.io/managed-by: "Helm"
    app.kubernetes.io/instance: "release-name"
    helm.sh/chart: "coredns-1.27.1"
    k8s-app: coredns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
    app.kubernetes.io/name: coredns
rules:
- apiGroups:
  - ""
  resources:
  - endpoints
  - services
  - pods
  - namespaces
  verbs:
  - list
  - watch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - list
  - watch

---
# Source: coredns/templates/clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: coredns
  labels:
    app.kubernetes.io/managed-by: "Helm"
    app.kubernetes.io/instance: "release-name"
    helm.sh/chart: "coredns-1.27.1"
    k8s-app: coredns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
    app.kubernetes.io/name: coredns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: coredns
subjects:
- kind: ServiceAccount
  name: coredns
  namespace: kube-system

---
# Source: coredns/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
  labels:
    app.kubernetes.io/managed-by: "Helm"
    app.kubernetes.io/instance: "release-name"
    helm.sh/chart: "coredns-1.27.1"
    k8s-app: coredns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
    app.kubernetes.io/name: coredns
data:
  Corefile: |-
    .:53 {
        errors
        health {
            lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
            ttl 30
        }
        prometheus 0.0.0.0:9153
        forward . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }

---
# Source: coredns/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns
  namespace: kube-system
  labels:
    app.kubernetes.io/managed-by: "Helm"
    app.kubernetes.io/instance: "release-name"
    helm.sh/chart: "coredns-1.27.1"
    k8s-app: coredns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
    app.kubernetes.io/name: coredns
    app.kubernetes.io/version: "1.11.1"
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 25%
  selector:
    matchLabels:
      app.kubernetes.io/instance: "release-name"
      k8s-app: coredns
      app.kubernetes.io/name: coredns
  template:
    metadata:
      namespace: kube-system
      labels:
        k8s-app: coredns
        app.kubernetes.io/name: coredns
        app.kubernetes.io/instance: "release-name"
      annotations:
        checksum/config: 73026f5854f730d4154f1c671ff0cb0a5ffcdfeb7eea42f1cb7df15225915f65
        scheduler.alpha.kubernetes.io/tolerations: '[{"key":"CriticalAddonsOnly", "operator":"Exists"}]'
    spec:
      terminationGracePeriodSeconds: 30
      serviceAccountName: coredns
      dnsPolicy: Default
      containers:
      - name: "coredns"
        image: "coredns/coredns:1.11.1"
        imagePullPolicy: IfNotPresent
        args: [ "-conf", "/etc/coredns/Corefile" ]
        volumeMounts:
        - name: config-volume
          mountPath: /etc/coredns
        resources:
          limits:
            cpu: 100m
            memory: 128Mi
          requests:
            cpu: 100m
            memory: 128Mi
        ports:
        - {"containerPort":53,"name":"udp-53","protocol":"UDP"}
        - {"containerPort":53,"name":"tcp-53","protocol":"TCP"}
        - {"containerPort":9153,"name":"tcp-9153","protocol":"TCP"}
        
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 60
          periodSeconds: 10
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: 8181
            scheme: HTTP
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        securityContext:
          capabilities:
            add:
            - NET_BIND_SERVICE
      volumes:
        - name: config-volume
          configMap:
            name: coredns
            items:
            - key: Corefile
              path: Corefile

---
# Source: coredns/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: coredns
  namespace: kube-system
  labels:
    app.kubernetes.io/managed-by: "Helm"
    app.kubernetes.io/instance: "release-name"
    helm.sh/chart: "coredns-1.27.1"
    k8s-app: coredns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
    app.kubernetes.io/name: coredns
spec:
  selector:
    app.kubernetes.io/instance: "release-name"
    k8s-app: coredns
    app.kubernetes.io/name: coredns
  ports:
  - {"name":"udp-53","port":53,"protocol":"UDP"}
  - {"name":"tcp-53","port":53,"protocol":"TCP"}
  type: ClusterIP
EOF