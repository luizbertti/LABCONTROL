# Load configuration
. "$PSScriptRoot\..\Core\Config.ps1"

# Load profile module
. "$PSScriptRoot\..\Core\Profile.ps1"

# Load browser module
. "$PSScriptRoot\..\Core\Browser.ps1"

# Initialize configuration
Initialize-LabControl

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL BROWSER TEST"
Write-Host "========================================"
Write-Host ""

$Browser = "Chrome"

Write-Host "Browser:" $Browser
Write-Host ""

Write-Host "Restoring profile..."

Restore-Profile -Browser $Browser

Write-Host ""
Write-Host "Starting browser..."

$Started = Start-Browser -Browser $Browser

Write-Host ""
Write-Host "Browser running:" $Started