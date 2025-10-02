# Push Changes to GitHub
Write-Host "Pushing changes to GitHub..." -ForegroundColor Green
Write-Host ""

# Check current branch
$branch = git branch --show-current
Write-Host "Current branch: $branch" -ForegroundColor Cyan

# Add all changes
Write-Host "Adding files..." -ForegroundColor Yellow
git add .

# Show status
Write-Host ""
Write-Host "Files to be committed:" -ForegroundColor Yellow
git status --short

# Commit
Write-Host ""
$commitMessage = Read-Host "Enter commit message (or press Enter for default)"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Add monitoring stack and access documentation"
}

Write-Host "Committing with message: $commitMessage" -ForegroundColor Yellow
git commit -m "$commitMessage"

# Push
Write-Host ""
Write-Host "Pushing to origin/$branch..." -ForegroundColor Yellow
git push origin $branch

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "Successfully pushed to GitHub!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "View your changes at:" -ForegroundColor Cyan
Write-Host "https://github.com/bashairfan0911/retail-store-sample-app/tree/$branch" -ForegroundColor White
Write-Host ""
