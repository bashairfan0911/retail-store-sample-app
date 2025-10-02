# 🔄 ArgoCD Sync Guide

## Why Changes Don't Reflect Immediately

ArgoCD checks your Git repository for changes every **3 minutes** by default. This is normal behavior!

---

## ⚡ Quick Sync (Force Immediate Update)

### Option 1: Use the Script (Recommended)
```powershell
.\sync-argocd.ps1
```

This will:
1. List all applications
2. Force refresh each application
3. Show current sync status

---

### Option 2: Manual Refresh via kubectl

**Refresh all applications:**
```bash
kubectl patch application retail-store-ui -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
kubectl patch application retail-store-catalog -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
kubectl patch application retail-store-cart -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
kubectl patch application retail-store-checkout -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
kubectl patch application retail-store-orders -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
```

**Or refresh a specific application:**
```bash
kubectl patch application retail-store-ui -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
```

---

### Option 3: Use ArgoCD UI

**Step 1:** Start port forwarding
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

**Step 2:** Open browser to http://localhost:8080

**Step 3:** Login with:
- Username: `admin`
- Password: Get it with:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
  ```

**Step 4:** Click on an application and click "REFRESH" or "SYNC"

---

## 🔍 Check Sync Status

### View all applications
```bash
kubectl get applications -n argocd
```

### View detailed status
```bash
kubectl get application retail-store-ui -n argocd -o yaml
```

### Check last sync time
```bash
kubectl get applications -n argocd -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status,LAST-SYNC:.status.operationState.finishedAt
```

---

## ⏱️ Understanding ArgoCD Sync Behavior

### Automatic Sync (Enabled)
Your applications have `automated: true` which means:
- ✅ ArgoCD checks Git every **3 minutes**
- ✅ Automatically syncs when changes are detected
- ✅ `selfHeal: true` - fixes drift if someone manually changes resources
- ✅ `prune: true` - removes resources deleted from Git

### Sync Frequency
Default: **3 minutes**

To change this, you would need to modify ArgoCD's ConfigMap:
```bash
kubectl edit configmap argocd-cm -n argocd
```

Add:
```yaml
data:
  timeout.reconciliation: 60s  # Check every 60 seconds
```

---

## 📋 Complete Workflow

### 1. Make Changes to Code
```bash
# Edit files
vim src/ui/chart/values.yaml
```

### 2. Commit and Push
```bash
git add .
git commit -m "Update UI configuration"
git push origin gitops
```

### 3. Force Sync (Optional - for immediate update)
```powershell
.\sync-argocd.ps1
```

### 4. Verify Changes
```bash
# Check application status
kubectl get applications -n argocd

# Check pods
kubectl get pods -n retail-store

# Check if new version is deployed
kubectl describe pod -n retail-store <pod-name> | grep Image
```

---

## 🐛 Troubleshooting

### Application shows "OutOfSync"
This is normal! It means ArgoCD detected changes but hasn't synced yet.

**Solution:** Wait 3 minutes or force sync:
```powershell
.\sync-argocd.ps1
```

### Application shows "Unknown" or "Progressing"
The application is being deployed.

**Check status:**
```bash
kubectl get pods -n retail-store
kubectl logs -n retail-store <pod-name>
```

### Application shows "Degraded" or "Failed"
There's an issue with the deployment.

**Check details:**
```bash
kubectl get application retail-store-ui -n argocd -o yaml
kubectl describe pod -n retail-store <pod-name>
kubectl logs -n retail-store <pod-name>
```

### Changes not appearing after 5+ minutes
**Check if commit was pushed:**
```bash
git log --oneline -5
git status
```

**Check ArgoCD is watching correct branch:**
```bash
kubectl get application retail-store-ui -n argocd -o yaml | grep -A 5 "source:"
```

Should show:
```yaml
source:
  repoURL: https://github.com/bashairfan0911/retail-store-sample-app
  targetRevision: gitops
  path: src/ui/chart
```

---

## 🎯 Best Practices

### 1. Always Push to Git First
```bash
git push origin gitops
```

### 2. Wait or Force Sync
Either:
- Wait 3 minutes for auto-sync
- Or run: `.\sync-argocd.ps1`

### 3. Verify Deployment
```bash
kubectl get pods -n retail-store
kubectl get applications -n argocd
```

### 4. Check Logs if Issues
```bash
kubectl logs -n retail-store -l app.kubernetes.io/name=ui --tail=50
```

---

## 📊 Monitoring ArgoCD

### Watch for changes in real-time
```bash
watch -n 5 kubectl get applications -n argocd
```

### View ArgoCD logs
```bash
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server --tail=100 -f
```

### View repo-server logs (Git sync)
```bash
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server --tail=100 -f
```

---

## 🚀 Quick Reference

| Action | Command |
|--------|---------|
| **Force sync all** | `.\sync-argocd.ps1` |
| **Check status** | `kubectl get applications -n argocd` |
| **View details** | `kubectl get application <name> -n argocd -o yaml` |
| **Access UI** | `kubectl port-forward svc/argocd-server -n argocd 8080:80` |
| **Get password** | `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' \| base64 -d` |

---

## 💡 Pro Tips

1. **Use the sync script after every push:**
   ```bash
   git push origin gitops && .\sync-argocd.ps1
   ```

2. **Create an alias:**
   ```bash
   # Add to your PowerShell profile
   function Sync-ArgoCD { .\sync-argocd.ps1 }
   Set-Alias -Name argocd-sync -Value Sync-ArgoCD
   ```

3. **Monitor in ArgoCD UI:**
   - Keep ArgoCD UI open in browser
   - Watch real-time sync status
   - See detailed deployment logs

---

**Remember:** ArgoCD auto-sync is working! It just takes up to 3 minutes. Use the sync script for immediate updates! 🚀
