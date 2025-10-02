# 🚀 Quick Start Guide

## What You Have Deployed

✅ **Retail Store Application** - Full e-commerce app with microservices
✅ **Monitoring Stack** - Prometheus + Grafana for metrics and dashboards
✅ **GitOps** - ArgoCD for continuous deployment
✅ **Kubernetes Cluster** - EKS on AWS with auto-scaling

---

## 🎯 3 Simple Steps to Get Started

### Step 1: Access the Retail Store
Open your browser and go to:
```
http://k8s-ingressn-ingressn-b81d5b7b46-3a4c63d7d41297d2.elb.us-west-2.amazonaws.com
```

### Step 2: Start Monitoring
Run in PowerShell:
```powershell
.\start-monitoring.ps1
```

### Step 3: Push to GitHub
Run in PowerShell:
```powershell
.\push-to-github.ps1
```

**That's it!** 🎉

---

## 📚 Detailed Guides

- **[HOW-TO-ACCESS.md](HOW-TO-ACCESS.md)** - Complete access guide for all services
- **[GIT-COMMANDS.md](GIT-COMMANDS.md)** - Git commands reference
- **[access-monitoring.md](access-monitoring.md)** - Monitoring stack details

---

## 🛠️ Quick Commands

### Check Everything is Running
```bash
kubectl get pods -A
```

### View Retail Store Status
```bash
kubectl get pods -n retail-store
kubectl get svc -n retail-store
kubectl get ingress -n retail-store
```

### View Monitoring Status
```bash
kubectl get pods -n monitoring
```

### View ArgoCD Applications
```bash
kubectl get applications -n argocd
```

### View Logs
```bash
# UI logs
kubectl logs -n retail-store -l app.kubernetes.io/name=ui --tail=50 -f

# All logs
kubectl logs -n retail-store --all-containers=true --tail=100
```

---

## 🔗 Important URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **Retail Store** | http://k8s-ingressn-ingressn-b81d5b7b46-3a4c63d7d41297d2.elb.us-west-2.amazonaws.com | None |
| **Grafana** | http://localhost:3000 (after port-forward) | admin / prom-operator |
| **Prometheus** | http://localhost:9090 (after port-forward) | None |
| **ArgoCD** | http://localhost:8080 (after port-forward) | admin / (get from secret) |

---

## 📦 What's Included

### Retail Store Microservices
- **UI** - Frontend application
- **Catalog** - Product catalog service
- **Cart** - Shopping cart service
- **Checkout** - Checkout service
- **Orders** - Order management service

### Monitoring Stack
- **Prometheus** - Metrics collection
- **Grafana** - Dashboards and visualization
- **Alertmanager** - Alert management
- **Node Exporter** - Node metrics
- **Kube State Metrics** - Kubernetes metrics

### Infrastructure
- **EKS Cluster** - Managed Kubernetes on AWS
- **VPC** - Isolated network
- **Load Balancer** - NGINX Ingress Controller
- **Auto Scaling** - Karpenter for node scaling
- **GitOps** - ArgoCD for deployment automation

---

## 🎓 Next Steps

1. **Explore Grafana Dashboards**
   - Login to Grafana
   - Browse pre-built Kubernetes dashboards
   - Create custom dashboards for retail store metrics

2. **Monitor Application Metrics**
   - Open Prometheus
   - Run queries to see application metrics
   - Set up alerts

3. **Use ArgoCD**
   - View application sync status
   - Manually sync applications
   - Monitor deployment health

4. **Customize the Application**
   - Modify Helm charts in `src/*/chart/`
   - Commit changes to GitHub
   - Watch ArgoCD auto-deploy

---

## 🐛 Troubleshooting

**Problem:** Retail store shows 500 error
```bash
kubectl logs -n retail-store -l app.kubernetes.io/name=ui --tail=50
kubectl rollout restart deployment -n retail-store
```

**Problem:** Port forward fails
```bash
# Check if port is in use
netstat -ano | findstr :3000

# Use different port
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3001:80
```

**Problem:** Services not responding
```bash
kubectl get pods -n retail-store
kubectl describe pod -n retail-store <pod-name>
```

---

## 📞 Support

- Check logs: `kubectl logs -n retail-store <pod-name>`
- Describe resources: `kubectl describe pod -n retail-store <pod-name>`
- View events: `kubectl get events -n retail-store --sort-by='.lastTimestamp'`

---

**Happy deploying! 🚀**
