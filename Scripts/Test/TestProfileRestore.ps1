# Load configuration
. "$PSScriptRoot\..\Core\Config.ps1"

# Load profile module
. "$PSScriptRoot\..\Core\Profile.ps1"

# Initialize configuration
Initialize-LabControl

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL PROFILE RESTORE TEST"
Write-Host "========================================"
Write-Host ""

$Browser = "Chrome"

$Template = Get-ProfileTemplate -Browser $Browser
$Runtime = Get-ProfileRuntime -Browser $Browser

Write-Host "Browser : $Browser"
Write-Host "Template: $Template"
Write-Host "Runtime : $Runtime"
Write-Host ""

Write-Host "Restoring profile..."

Restore-Profile -Browser $Browser

Write-Host ""
Write-Host "Profile restored."
Write-Host ""

Write-Host "Runtime contents:"
Get-ChildItem -Path $Runtime | Select-Object Name, Mode