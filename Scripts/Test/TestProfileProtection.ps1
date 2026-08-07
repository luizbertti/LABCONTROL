# Load configuration
. "$PSScriptRoot\..\Core\Config.ps1"

# Load profile module
. "$PSScriptRoot\..\Core\Profile.ps1"

# Initialize configuration
Initialize-LabControl

$Browser = "Edge"

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL PROFILE PROTECTION TEST"
Write-Host "========================================"
Write-Host ""

Write-Host "Browser:" $Browser
Write-Host ""

Write-Host "Profile in use:" (Test-ProfileInUse -Browser $Browser)

Write-Host ""

try {

    Clear-ProfileRuntime -Browser $Browser

    Write-Host "[ OK ] Runtime cleared successfully."

}
catch {

    Write-Host "[FAIL] $($_.Exception.Message)"

}