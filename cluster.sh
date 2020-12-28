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

# Exit
rm local-cluster.yaml
exit $?