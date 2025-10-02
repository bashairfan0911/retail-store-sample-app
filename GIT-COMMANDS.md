# Git Commands Reference

## 🚀 Quick Push (Recommended)

Run the automated script:
```powershell
.\push-to-github.ps1
```

This will:
1. Add all changes
2. Show you what will be committed
3. Ask for a commit message
4. Commit and push to GitHub

---

## 📝 Manual Git Commands

### 1. Check Status
```bash
git status
```

### 2. Add All Changes
```bash
git add .
```

Or add specific files:
```bash
git add HOW-TO-ACCESS.md
git add start-monitoring.ps1
git add monitoring-ingress.yaml
git add retail-store-servicemonitors.yaml
```

### 3. Commit Changes
```bash
git commit -m "Add monitoring stack and access documentation"
```

### 4. Push to GitHub
```bash
git push origin gitops
```

---

## 🔄 Common Git Workflows

### Push All Changes
```bash
git add .
git commit -m "Your commit message here"
git push origin gitops
```

### Check What Changed
```bash
git status
git diff
```

### View Commit History
```bash
git log --oneline
git log --graph --oneline --all
```

### Pull Latest Changes
```bash
git pull origin gitops
```

### Create New Branch
```bash
git checkout -b feature/new-feature
git push origin feature/new-feature
```

### Switch Branches
```bash
git checkout main
git checkout gitops
```

---

## 📦 What Will Be Pushed

Current untracked files:
- `HOW-TO-ACCESS.md` - Complete access guide
- `access-monitoring.md` - Monitoring access details
- `start-monitoring.ps1` - Quick start script for monitoring
- `monitoring-ingress.yaml` - Ingress configuration
- `retail-store-servicemonitors.yaml` - Prometheus ServiceMonitors
- `push-to-github.ps1` - This push script
- `GIT-COMMANDS.md` - This file

Modified files:
- `src/ui/chart/values.yaml` - Updated with correct endpoints
- `src/cart/chart/values.yaml` - Fixed syntax error
- `terraform/addons.tf` - Disabled AWS Load Balancer Controller

---

## 🔐 Authentication

If you're prompted for credentials:

**HTTPS (Username/Password or Token):**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**SSH (Recommended):**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub
# Copy the public key and add it to GitHub Settings > SSH Keys
cat ~/.ssh/id_ed25519.pub
```

---

## 🐛 Troubleshooting

### If push is rejected:
```bash
# Pull first, then push
git pull origin gitops --rebase
git push origin gitops
```

### If you have merge conflicts:
```bash
# Resolve conflicts in files, then:
git add .
git rebase --continue
git push origin gitops
```

### Undo last commit (keep changes):
```bash
git reset --soft HEAD~1
```

### Discard all local changes:
```bash
git reset --hard HEAD
git clean -fd
```

---

## 📊 Current Repository Info

- **Repository:** https://github.com/bashairfan0911/retail-store-sample-app
- **Current Branch:** gitops
- **Remote:** origin

---

**Ready to push? Run:** `.\push-to-github.ps1` 🚀
