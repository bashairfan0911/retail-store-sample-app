# Access Monitoring Stack

## Grafana Dashboard

### Step 1: Start Port Forward
Open a **new terminal window** and run:
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

### Step 2: Access Grafana
Open your browser and go to: **http://localhost:3000**

### Step 3: Login
- Username: `admin`
- Password: `prom-operator`

Keep the terminal window open while using Grafana!

---

## Prometheus

### Step 1: Start Port Forward
Open a **new terminal window** and run:
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
```

### Step 2: Access Prometheus
Open your browser and go to: **http://localhost:9090**

---

## Quick Access Script (Windows PowerShell)

Save this as `start-monitoring.ps1`:

```powershell
# Start Grafana
Start-Process powershell -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80"

# Wait a bit
Start-Sleep -Seconds 2

# Start Prometheus
Start-Process powershell -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090"

# Open browsers
Start-Sleep -Seconds 3
Start-Process "http://localhost:3000"
Start-Process "http://localhost:9090"

Write-Host "Grafana: http://localhost:3000 (admin/prom-operator)"
Write-Host "Prometheus: http://localhost:9090"
```

Then run: `.\start-monitoring.ps1`
