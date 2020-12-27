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

API load test with [Vegeta](https://github.com/tsenart/vegeta)

```bash
echo "GET http://localhost/api/v1/info" | vegeta attack -rate=50/s -duration=15s | tee results.bin | vegeta report
cat results.bin | vegeta plot > report.html
```