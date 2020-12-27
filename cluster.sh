#!/usr/bin/env bash
set -euo pipefail

# Delete cluster
kind delete cluster --name local

# Create cluster
cat << EOF > local-cluster.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF
kind create cluster --name local --config ./local-cluster.yaml

# Neginx Ingress controller
kubectl label nodes local-control-plane ingress-ready=true
curl -s -k https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml | kubectl apply -f -
kubectl wait --namespace ingress-nginx --for=condition=Ready pod --selector=app.kubernetes.io/component=controller --timeout=180s

# App
kubectl create -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: app
EOF

app_list=(maracuja cavalo caipirinha)
for app_name in "${app_list[@]}" ; do
  kubectl create -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${app_name}
  namespace: app
  labels:
    app: ${app_name}
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ${app_name}
  template:
    metadata:
      labels:
        app: ${app_name}
    spec:
      containers:
      - name: ${app_name}
        image: hashicorp/http-echo
        imagePullPolicy: IfNotPresent
        args:
          - "-text=${app_name}"      
        ports:
          - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: ${app_name}
  name: ${app_name}
  namespace: app
spec:
  ports:
  - port: 5678
    protocol: TCP
    targetPort: 5678
  selector:
    app: ${app_name}
  sessionAffinity: None
  type: ClusterIP
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ${app_name}
  namespace: app
spec:
  rules:
  - host: localhost
    http:
      paths:
      - backend:
          serviceName: ${app_name}
          servicePort: 5678
        path: /${app_name}
EOF
done

exit $?