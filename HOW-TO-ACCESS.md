# 🚀 How to Access Your Applications

## ✅ What's Running

All services are deployed and running:
- ✅ Retail Store Application (UI, Catalog, Cart, Checkout, Orders)
- ✅ Monitoring Stack (Prometheus, Grafana, Alertmanager)
- ✅ ArgoCD (GitOps)

---

## 🛍️ 1. Retail Store Application

**URL:** http://k8s-ingressn-ingressn-b81d5b7b46-3a4c63d7d41297d2.elb.us-west-2.amazonaws.com

Just open this URL in your browser - no login required!

**What you can do:**
- Browse products
- Add items to cart
- Complete checkout
- View orders

---

## 📊 2. Grafana (Monitoring Dashboards)

### Quick Start:
```powershell
.\start-monitoring.ps1
```

This will:
1. Start port forwarding for Grafana and Prometheus
2. Open both in your browser automatically

### Manual Access:

**Step 1:** Open a new terminal and run:
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

**Step 2:** Open browser to: http://localhost:3000

**Step 3:** Login with:
- Username: `admin`
- Password: `prom-operator`

**Keep the terminal open while using Grafana!**

---

## 🔍 3. Prometheus (Metrics)

**Step 1:** Open a new terminal and run:
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
```

**Step 2:** Open browser to: http://localhost:9090

**Try these queries:**
```promql
# HTTP requests per second
rate(http_server_requests_seconds_count{namespace="retail-store"}[5m])

# Memory usage
container_memory_usage_bytes{namespace="retail-store"}

# CPU usage
rate(container_cpu_usage_seconds_total{namespace="retail-store"}[5m])
```

---

## 🔄 4. ArgoCD (GitOps Dashboard)

**Step 1:** Open a new terminal and run:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

**Step 2:** Open browser to: http://localhost:8080

**Step 3:** Get the password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

**Step 4:** Login with:
- Username: `admin`
- Password: (from step 3)

---

## 🛠️ Useful Commands

### Check Status
```bash
# All retail store pods
kubectl get pods -n retail-store

# All ArgoCD applications
kubectl get applications -n argocd

# All ingresses
kubectl get ingress -A
```

### View Logs
```bash
# UI logs
kubectl logs -n retail-store -l app.kubernetes.io/name=ui --tail=50 -f

# All retail store logs
kubectl logs -n retail-store --all-containers=true --tail=100
```

### Restart Services
```bash
# Restart UI
kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=ui

# Restart all
kubectl rollout restart deployment -n retail-store
```

---

## 🎯 Quick Summary

| Service | Access Method | URL | Credentials |
|---------|---------------|-----|-------------|
| **Retail Store** | Direct | http://k8s-ingressn-ingressn-b81d5b7b46-3a4c63d7d41297d2.elb.us-west-2.amazonaws.com | None |
| **Grafana** | Port Forward | http://localhost:3000 | admin / prom-operator |
| **Prometheus** | Port Forward | http://localhost:9090 | None |
| **ArgoCD** | Port Forward | http://localhost:8080 | admin / (get from secret) |

---

## 🐛 Troubleshooting

**If retail store shows 500 error:**
```bash
kubectl logs -n retail-store -l app.kubernetes.io/name=ui --tail=50
kubectl get pods -n retail-store
```

**If port forward fails:**
- Check if port is already in use: `netstat -ano | findstr :3000`
- Kill the process or use a different port
- Make sure kubectl is connected: `kubectl get nodes`

**If services are not responding:**
```bash
# Check pod status
kubectl get pods -n retail-store

# Restart services
kubectl rollout restart deployment -n retail-store
```

---

## 📝 Files Created

- `start-monitoring.ps1` - Quick script to start Grafana and Prometheus
- `access-monitoring.md` - Detailed monitoring access guide
- `monitoring-ingress.yaml` - Ingress configuration (not used, using port-forward instead)
- `retail-store-servicemonitors.yaml` - Prometheus service monitors

---

**Enjoy your fully deployed retail store with monitoring! 🎉**
