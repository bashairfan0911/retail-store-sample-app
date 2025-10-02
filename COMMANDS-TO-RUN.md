# 🚀 All Commands to Run

## 1️⃣ Push README Changes to GitHub

```bash
# Add all changes
git add .

# Commit with message
git commit -m "Update all service README files with deployment status"

# Push to GitHub
git push origin gitops
```

---

## 2️⃣ Force ArgoCD to Sync (Optional - for immediate update)

```powershell
# Run the sync script
.\sync-argocd.ps1
```

**OR wait 3 minutes for auto-sync**

---

## 3️⃣ Verify Changes Were Deployed

```bash
# Check ArgoCD application status
kubectl get applications -n argocd

# Check if pods restarted (they won't for README changes, but you can verify sync)
kubectl get pods -n retail-store

# View ArgoCD sync status
kubectl get application retail-store-ui -n argocd -o yaml | grep -A 5 "status:"
```

---

## 4️⃣ Access Monitoring (Optional)

```powershell
# Start Grafana and Prometheus
.\start-monitoring.ps1
```

Then open:
- Grafana: http://localhost:3000 (admin/prom-operator)
- Prometheus: http://localhost:9090

---

## 5️⃣ Access ArgoCD UI (Optional)

```bash
# Port forward ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

Then open: http://localhost:8080

Get password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

---

## 6️⃣ Check Application Status

```bash
# Get all pods
kubectl get pods -n retail-store

# Get all services
kubectl get svc -n retail-store

# Get ingress
kubectl get ingress -n retail-store

# Get load balancer URL
kubectl get svc -n ingress-nginx ingress-nginx-controller -o yaml | grep hostname
```

---

## 🎯 Quick One-Liner (Push + Sync)

```bash
git add . && git commit -m "Update README files" && git push origin gitops && .\sync-argocd.ps1
```

---

## 📝 What Changed

Updated README.md files in:
- ✅ src/ui/README.md
- ✅ src/catalog/README.md
- ✅ src/cart/README.md
- ✅ src/checkout/README.md
- ✅ src/orders/README.md

Each now shows:
- Last updated date
- ArgoCD GitOps deployment status
- Current version info

---

## ⏱️ Expected Timeline

1. **Push to GitHub:** Instant
2. **ArgoCD detects change:** Up to 3 minutes (or instant with sync script)
3. **Sync completes:** 10-30 seconds

**Note:** README changes don't trigger pod restarts, but you'll see the sync status update in ArgoCD!

---

## 🔍 Verify in ArgoCD UI

After syncing, you'll see:
- ✅ All applications show "Synced" status
- ✅ Last sync time updated
- ✅ Commit hash matches your latest commit

---

**Ready to run? Copy and paste the commands above! 🚀**
