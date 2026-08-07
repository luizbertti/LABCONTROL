# Load configuration
. "$PSScriptRoot\..\Core\Config.ps1"

# Load profile module
. "$PSScriptRoot\..\Core\Profile.ps1"

# Initialize configuration
Initialize-LabControl

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL PROFILE TEST"
Write-Host "========================================"
Write-Host ""

foreach ($Browser in @("Chrome", "Edge")) {

    Write-Host $Browser
    Write-Host "--------"

    $Template = Get-ProfileTemplate -Browser $Browser
    $Runtime = Get-ProfileRuntime -Browser $Browser

    Write-Host "Template:"
    Write-Host $Template

    Write-Host "Template exists:" (Test-Path $Template -PathType Container)

    Write-Host ""

    Write-Host "Runtime:"
    Write-Host $Runtime

    Write-Host "Runtime exists:" (Test-Path $Runtime -PathType Container)

    Write-Host ""
}