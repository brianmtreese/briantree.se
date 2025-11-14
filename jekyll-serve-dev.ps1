# PowerShell script to run Jekyll with development optimizations
# Uses client-side auto-refresh (EventMachine C extension has compatibility issues with Ruby 3.3+)

# Check if --clean flag is passed
param(
    [switch]$clean
)

# If --clean flag is used, clear Jekyll cache and rebuild
if ($clean) {
    Write-Host "Clearing Jekyll cache..." -ForegroundColor Yellow
    if (Test-Path ".jekyll-cache") {
        Remove-Item -Recurse -Force ".jekyll-cache"
        Write-Host "Cache cleared." -ForegroundColor Green
    }
    if (Test-Path "_site") {
        Remove-Item -Recurse -Force "_site"
        Write-Host "Site directory cleared." -ForegroundColor Green
    }
    Write-Host "Starting fresh build..." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Starting Jekyll with development optimizations..." -ForegroundColor Cyan
Write-Host "Client-side auto-refresh enabled - browser will refresh automatically when pages are rebuilt." -ForegroundColor Cyan
Write-Host ""
Write-Host "TIP: If a new post doesn't appear, stop the server and run: .\jekyll-serve-dev.ps1 -clean" -ForegroundColor Yellow
Write-Host ""

# Run Jekyll with incremental regeneration and development config
# --force_polling helps with file detection on Windows, especially for new files
# Client-side auto-refresh script will automatically refresh the browser when pages are rebuilt
bundle exec jekyll serve --incremental --force_polling --config _config.yml,_config_dev.yml

