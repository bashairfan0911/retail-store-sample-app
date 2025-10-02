# 📜 Deployment History & Scripts

## 🎯 Project Overview

**Project:** Retail Store Sample Application on AWS EKS
**Date:** October 2, 2025
**Region:** us-west-2
**Cluster:** retail-store-2zn5

---

## 📋 Deployment Timeline

### 1. Initial Infrastructure Setup
```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply infrastructure
terraform apply -auto-approve
```

**What was deployed:**
- ✅ VPC with public and private subnets
- ✅ EKS Cluster (v1.33)
- ✅ Node groups with Karpenter autoscaling
- ✅ Security groups and IAM roles

---

### 2. EKS Add-ons Installation

**Installed Components:**
- ✅ Cert-Manager (SSL certificate management)
- ✅ NGINX Ingress Controller (Load balancing)
- ✅ Kube Prometheus Stack (Monitoring)
- ✅ ArgoCD (GitOps)

**Key Configuration Changes:**
- Disabled AWS Load Balancer Controller (conflicted with NGINX)
- Configured NGINX with NLB annotations
- Added wait and timeout settings for helm releases

---

### 3. Issues Encountered & Fixes

#### Issue 1: AWS Load Balancer Controller Webhook Conflict
**Problem:** AWS Load Balancer Controller webhook was blocking other services
**Solution:** 
```bash
# Removed AWS Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system

# Updated terraform/addons.tf to disable it
# enable_aws_load_balancer_controller = false
```

#### Issue 2: UI Chart Missing Values
**Problem:** Helm chart had missing required values (certManager, istio, app.chat)
**Solution:**
```bash
# Fixed src/ui/chart/values.yaml
git add src/ui/chart/values.yaml
git commit -m "Add missing certManager, istio, and app configuration"
git push origin gitops
```

#### Issue 3: Cart Service YAML Syntax Error
**Problem:** Extra `.` at beginning of src/cart/chart/values.yaml
**Solution:**
```bash
# Fixed the syntax error
git add src/cart/chart/values.yaml
git commit -m "Fix cart values.yaml syntax error"
git push origin gitops
```

#### Issue 4: Wrong Cart Service Name
**Problem:** UI was looking for `retail-store-cart` but service was named `retail-store-cart-carts`
**Solution:**
```bash
# Updated UI endpoint configuration
git add src/ui/chart/values.yaml
git commit -m "Fix cart service endpoint name"
git push origin gitops

# Restarted UI deployment
kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=ui
```

---

## 🚀 Final Deployment Commands

### Configure kubectl
```bash
aws eks update-kubeconfig --region us-west-2 --name retail-store-2zn5
```

### Deploy ArgoCD Applications
```bash
# Apply projects
kubectl apply -n argocd -f argocd/projects/

# Apply applications
kubectl apply -n argocd -f argocd/applications/
```

### Enable Monitoring
```bash
# Create ServiceMonitors for retail store apps
kubectl apply -f retail-store-servicemonitors.yaml

# Verify monitoring
kubectl get servicemonitor -n monitoring | grep retail-store
```

---

## 📊 Current Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     AWS EKS Cluster                         │
│                   (retail-store-2zn5)                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────┐     │
│  │           NGINX Ingress Controller               │     │
│  │  (NLB: k8s-ingressn-ingressn-b81d5b7b46...)     │     │
│  └──────────────────────────────────────────────────┘     │
│                          │                                  │
│  ┌───────────────────────┴──────────────────────────┐     │
│  │                                                   │     │
│  │  ┌─────────────────────────────────────────┐    │     │
│  │  │      Retail Store Namespace             │    │     │
│  │  ├─────────────────────────────────────────┤    │     │
│  │  │  • retail-store-ui                      │    │     │
│  │  │  • retail-store-catalog                 │    │     │
│  │  │  • retail-store-cart-carts              │    │     │
│  │  │  • retail-store-checkout                │    │     │
│  │  │  • retail-store-orders                  │    │     │
│  │  └─────────────────────────────────────────┘    │     │
│  │                                                   │     │
│  │  ┌─────────────────────────────────────────┐    │     │
│  │  │      Monitoring Namespace               │    │     │
│  │  ├─────────────────────────────────────────┤    │     │
│  │  │  • Prometheus                           │    │     │
│  │  │  • Grafana                              │    │     │
│  │  │  • Alertmanager                         │    │     │
│  │  │  • Node Exporter                        │    │     │
│  │  │  • Kube State Metrics                   │    │     │
│  │  └─────────────────────────────────────────┘    │     │
│  │                                                   │     │
│  │  ┌─────────────────────────────────────────┐    │     │
│  │  │      ArgoCD Namespace                   │    │     │
│  │  ├─────────────────────────────────────────┤    │     │
│  │  │  • ArgoCD Server                        │    │     │
│  │  │  • ArgoCD Repo Server                   │    │     │
│  │  │  • ArgoCD Application Controller        │    │     │
│  │  └─────────────────────────────────────────┘    │     │
│  │                                                   │     │
│  └───────────────────────────────────────────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Useful Scripts

### 1. Start Monitoring Stack
```powershell
# start-monitoring.ps1
Write-Host "Starting Grafana and Prometheus port forwarding..." -ForegroundColor Green

# Start Grafana
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Grafana Port Forward - Keep this window open' -ForegroundColor Cyan; kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80"

Start-Sleep -Seconds 2

# Start Prometheus
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Prometheus Port Forward - Keep this window open' -ForegroundColor Cyan; kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090"

Start-Sleep -Seconds 5

# Open browsers
Start-Process "http://localhost:3000"
Start-Process "http://localhost:9090"

Write-Host ""
Write-Host "Grafana:    http://localhost:3000 (admin/prom-operator)" -ForegroundColor Cyan
Write-Host "Prometheus: http://localhost:9090" -ForegroundColor Cyan
```

**Usage:**
```powershell
.\start-monitoring.ps1
```

---

### 2. Check Application Status
```bash
#!/bin/bash
# check-status.sh

echo "=== Retail Store Pods ==="
kubectl get pods -n retail-store

echo ""
echo "=== ArgoCD Applications ==="
kubectl get applications -n argocd

echo ""
echo "=== Ingress Endpoints ==="
kubectl get ingress -A

echo ""
echo "=== Monitoring Pods ==="
kubectl get pods -n monitoring

echo ""
echo "=== Load Balancer URL ==="
kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo ""
```

**Usage:**
```bash
chmod +x check-status.sh
./check-status.sh
```

---

### 3. View Application Logs
```bash
#!/bin/bash
# view-logs.sh

SERVICE=$1

if [ -z "$SERVICE" ]; then
    echo "Usage: ./view-logs.sh [ui|catalog|cart|checkout|orders]"
    exit 1
fi

case $SERVICE in
    ui)
        kubectl logs -n retail-store -l app.kubernetes.io/name=ui --tail=100 -f
        ;;
    catalog)
        kubectl logs -n retail-store -l app.kubernetes.io/name=catalog --tail=100 -f
        ;;
    cart)
        kubectl logs -n retail-store -l app.kubernetes.io/name=carts --tail=100 -f
        ;;
    checkout)
        kubectl logs -n retail-store -l app.kubernetes.io/name=checkout --tail=100 -f
        ;;
    orders)
        kubectl logs -n retail-store -l app.kubernetes.io/name=orders --tail=100 -f
        ;;
    *)
        echo "Unknown service: $SERVICE"
        echo "Available: ui, catalog, cart, checkout, orders"
        exit 1
        ;;
esac
```

**Usage:**
```bash
chmod +x view-logs.sh
./view-logs.sh ui
```

---

### 4. Restart Services
```bash
#!/bin/bash
# restart-services.sh

SERVICE=$1

if [ -z "$SERVICE" ]; then
    echo "Restarting all retail store services..."
    kubectl rollout restart deployment -n retail-store
else
    echo "Restarting $SERVICE..."
    case $SERVICE in
        ui)
            kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=ui
            ;;
        catalog)
            kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=catalog
            ;;
        cart)
            kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=carts
            ;;
        checkout)
            kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=checkout
            ;;
        orders)
            kubectl rollout restart deployment -n retail-store -l app.kubernetes.io/name=orders
            ;;
        *)
            echo "Unknown service: $SERVICE"
            exit 1
            ;;
    esac
fi

echo "Done!"
```

**Usage:**
```bash
chmod +x restart-services.sh
./restart-services.sh ui
# or restart all
./restart-services.sh
```

---

### 5. Get ArgoCD Password
```bash
#!/bin/bash
# get-argocd-password.sh

echo "ArgoCD Admin Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
echo ""
```

**Usage:**
```bash
chmod +x get-argocd-password.sh
./get-argocd-password.sh
```

---

### 6. Port Forward All Services (PowerShell)
```powershell
# port-forward-all.ps1

Write-Host "Starting all port forwards..." -ForegroundColor Green

# Grafana
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Grafana (3000)' -ForegroundColor Cyan; kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80"

Start-Sleep -Seconds 1

# Prometheus
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Prometheus (9090)' -ForegroundColor Cyan; kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090"

Start-Sleep -Seconds 1

# ArgoCD
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'ArgoCD (8080)' -ForegroundColor Cyan; kubectl port-forward -n argocd svc/argocd-server 8080:80"

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "All services are now accessible:" -ForegroundColor Green
Write-Host "  Grafana:    http://localhost:3000 (admin/prom-operator)" -ForegroundColor Cyan
Write-Host "  Prometheus: http://localhost:9090" -ForegroundColor Cyan
Write-Host "  ArgoCD:     http://localhost:8080 (admin/<get-password>)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Keep all terminal windows open!" -ForegroundColor Yellow
```

**Usage:**
```powershell
.\port-forward-all.ps1
```

---

## 🌐 Access URLs

### Direct Access (via Load Balancer)
```
Retail Store: http://k8s-ingressn-ingressn-b81d5b7b46-3a4c63d7d41297d2.elb.us-west-2.amazonaws.com
```

### Port Forward Access
```
Grafana:    http://localhost:3000 (admin/prom-operator)
Prometheus: http://localhost:9090
ArgoCD:     http://localhost:8080 (admin/<password>)
```

---

## 📦 Git Commits Made

```bash
# 1. Fixed UI chart configuration
git commit -m "Fix UI chart: Add missing certManager and ingress configuration"

# 2. Added istio configuration
git commit -m "Add istio configuration to UI chart"

# 3. Added complete app configuration
git commit -m "Add complete app configuration to UI chart"

# 4. Fixed cart syntax error
git commit -m "Fix cart values.yaml syntax error"

# 5. Fixed cart service endpoint
git commit -m "Fix cart service endpoint name"

# 6. Updated terraform config
git commit -m "Update terraform addons config"
```

---

## 🔍 Monitoring Queries

### Prometheus Queries
```promql
# HTTP Request Rate
rate(http_server_requests_seconds_count{namespace="retail-store"}[5m])

# Memory Usage
container_memory_usage_bytes{namespace="retail-store"}

# CPU Usage
rate(container_cpu_usage_seconds_total{namespace="retail-store"}[5m])

# JVM Memory
jvm_memory_used_bytes{namespace="retail-store"}

# Pod Count
count(kube_pod_info{namespace="retail-store"})

# Request Duration (95th percentile)
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket{namespace="retail-store"}[5m]))
```

---

## 📝 Files Created

1. **Infrastructure:**
   - `terraform/addons.tf` - EKS add-ons configuration
   - `terraform/main.tf` - Main infrastructure
   - `terraform/variables.tf` - Variables

2. **Monitoring:**
   - `retail-store-servicemonitors.yaml` - Prometheus ServiceMonitors
   - `monitoring-ingress.yaml` - Ingress for monitoring (not used)

3. **Documentation:**
   - `HOW-TO-ACCESS.md` - Complete access guide
   - `access-monitoring.md` - Monitoring access details
   - `HISTORY.md` - This file

4. **Scripts:**
   - `start-monitoring.ps1` - Quick start monitoring
   - `port-forward-all.ps1` - Port forward all services

5. **Application Charts:**
   - `src/ui/chart/values.yaml` - Fixed UI configuration
   - `src/cart/chart/values.yaml` - Fixed cart configuration

---

## 🎓 Lessons Learned

1. **AWS Load Balancer Controller vs NGINX Ingress:**
   - Don't use both simultaneously - they conflict
   - NGINX Ingress with NLB annotations is simpler for this use case

2. **Helm Chart Values:**
   - Always validate all template references have corresponding values
   - Use `helm template` to test before deploying

3. **ArgoCD Auto-Sync:**
   - Auto-sync is great but sometimes needs manual refresh
   - Use `kubectl patch` to force refresh when needed

4. **Service Naming:**
   - Be consistent with service names across charts
   - Document the actual service names vs expected names

5. **Port Forwarding vs Ingress:**
   - Port forwarding is more reliable for admin tools
   - Ingress is better for public-facing applications

---

## 🚀 Next Steps

### Potential Improvements:
1. **Add SSL/TLS:**
   ```bash
   # Enable cert-manager ClusterIssuer
   # Configure ingress with TLS
   ```

2. **Add Horizontal Pod Autoscaling:**
   ```bash
   kubectl autoscale deployment -n retail-store retail-store-ui --cpu-percent=70 --min=2 --max=10
   ```

3. **Add Custom Grafana Dashboards:**
   - Create dashboards for retail store metrics
   - Import community dashboards

4. **Set up Alerting:**
   - Configure Alertmanager rules
   - Set up notification channels (Slack, email)

5. **Add Backup Strategy:**
   - Velero for cluster backups
   - Database backups if using persistent storage

---

## 📞 Support Commands

### Get Cluster Info
```bash
kubectl cluster-info
kubectl get nodes
kubectl get namespaces
```

### Troubleshooting
```bash
# Check pod events
kubectl describe pod -n retail-store <pod-name>

# Check service endpoints
kubectl get endpoints -n retail-store

# Check ingress details
kubectl describe ingress -n retail-store retail-store-ui

# Check logs from all containers
kubectl logs -n retail-store <pod-name> --all-containers=true
```

### Cleanup (if needed)
```bash
# Delete retail store
kubectl delete namespace retail-store

# Delete monitoring
kubectl delete namespace monitoring

# Delete ArgoCD
kubectl delete namespace argocd

# Destroy infrastructure
cd terraform
terraform destroy -auto-approve
```

---

**Last Updated:** October 2, 2025
**Status:** ✅ Fully Operational
**Maintained By:** DevOps Team
