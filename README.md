## Playground

### Components
- WSL2
- Docker
- Kind
- Simple API (Golang)
- Vegeta

### Getting started
1. Clone repository
2. Start Cluster

```bash
./cluster.sh
```

3. Build & Load image

```bash
make build

kind --name local load docker-image localhost/go-live:0.0.4
```

4. Deploy API

```bash
kubectl -n app apply -f deploy.yml
```

### Test

![alt text](images/http_200.png "HTTPie 200")

API load test with [Vegeta](https://github.com/tsenart/vegeta)

```bash
echo "GET http://localhost/api/v1/info" | vegeta attack -rate=100/s -duration=15s | tee results.bin | vegeta report
cat results.bin | vegeta plot > report.html
```

![alt text](images/vegeta.png "Vegeta Plot")

### CD

Simple CD with [ArgoCD](https://argoproj.github.io/argo-cd/)


```bash
# Create namespace
kubectl create namespace argocd

# Deploy Argo manifests
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Disable auth
kubectl patch deploy argocd-server -n argocd -p '[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--disable-auth"}]' --type json

# Forward port
kubectl port-forward svc/argocd-server -n argocd 9999:80
````

- CLI

```terminal
argocd login localhost:9999
argocd cluster add kind-local
argocd app list
argocd app get go-live
argocd app sync go-live
```

- UI

![alt text](images/argo.png "ArgoCD")