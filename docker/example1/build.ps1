# Exit immediately if any command fails.
$ErrorActionPreference = "Stop"

Write-Host "Initializing Packer configuration..." -ForegroundColor Cyan
packer init .

Write-Host "Formatting Packer templates..." -ForegroundColor Cyan
packer fmt .

Write-Host "Validating Packer configuration..." -ForegroundColor Cyan
packer validate .

Write-Host "Building Docker image using Packer..." -ForegroundColor Cyan
packer build docker-ubuntu.pkr.hcl

Write-Host "Listing Docker images to confirm the build..." -ForegroundColor Cyan
docker images

Write-Host "Build completed successfully!" -ForegroundColor Green