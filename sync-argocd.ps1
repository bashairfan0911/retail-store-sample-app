# Force ArgoCD to Sync Applications
Write-Host "Forcing ArgoCD to sync all applications..." -ForegroundColor Green
Write-Host ""

# Get all applications
$apps = kubectl get applications -n argocd -o jsonpath='{.items[*].metadata.name}'
$appList = $apps -split ' '

Write-Host "Found $($appList.Count) applications:" -ForegroundColor Cyan
foreach ($app in $appList) {
    Write-Host "  - $app" -ForegroundColor White
}

Write-Host ""
Write-Host "Refreshing applications..." -ForegroundColor Yellow

foreach ($app in $appList) {
    Write-Host "Refreshing $app..." -ForegroundColor Cyan
    kubectl patch application $app -n argocd --type merge -p '{\"metadata\":{\"annotations\":{\"argocd.argoproj.io/refresh\":\"hard\"}}}'
}

Write-Host ""
Write-Host "Waiting for sync to complete..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "Current application status:" -ForegroundColor Green
kubectl get applications -n argocd

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "ArgoCD sync triggered!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Applications will sync automatically within 3 minutes." -ForegroundColor Cyan
Write-Host "Or access ArgoCD UI to manually sync:" -ForegroundColor Cyan
Write-Host "  kubectl port-forward svc/argocd-server -n argocd 8080:80" -ForegroundColor White
Write-Host "  Then go to: http://localhost:8080" -ForegroundColor White
Write-Host ""
