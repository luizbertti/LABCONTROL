# Load configuration module

. "$PSScriptRoot\..\Core\Config.ps1"

Write-Host "Config module loaded."

Get-Command Get-LabConfig

Initialize-LabControl

Write-Host ""
Write-Host "==============================="
Write-Host " LABCONTROL CONFIG TEST"
Write-Host "==============================="
Write-Host ""

Write-Host "Project :" (Get-LabConfig).Project.Name
$version = Get-Version

Write-Host ("Version : {0}.{1}.{2}" -f `
    $version.Version.Major,
    $version.Version.Minor,
    $version.Version.Patch)
Write-Host "Chrome  :" (Get-ChromeConfig).Name
Write-Host "Edge    :" (Get-EdgeConfig).Name