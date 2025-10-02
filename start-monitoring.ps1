# Start Monitoring Stack Access
Write-Host "Starting Grafana and Prometheus port forwarding..." -ForegroundColor Green

# Start Grafana in new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Grafana Port Forward - Keep this window open' -ForegroundColor Cyan; kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80"

# Wait a bit
Start-Sleep -Seconds 2

# Start Prometheus in new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Prometheus Port Forward - Keep this window open' -ForegroundColor Cyan; kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090"

# Wait for services to be ready
Start-Sleep -Seconds 5

# Open browsers
Write-Host "Opening browsers..." -ForegroundColor Green
Start-Process "http://localhost:3000"
Start-Process "http://localhost:9090"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host "Monitoring Stack is now accessible!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Grafana:    http://localhost:3000" -ForegroundColor Cyan
Write-Host "  Username: admin" -ForegroundColor White
Write-Host "  Password: prom-operator" -ForegroundColor White
Write-Host ""
Write-Host "Prometheus: http://localhost:9090" -ForegroundColor Cyan
Write-Host ""
Write-Host "Keep the port-forward windows open!" -ForegroundColor Yellow
Write-Host "Press Ctrl+C in those windows to stop." -ForegroundColor Yellow
Write-Host ""
