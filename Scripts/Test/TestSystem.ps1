# Load system module
. "$PSScriptRoot\..\Core\System.ps1"

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL SYSTEM TEST"
Write-Host "========================================"
Write-Host ""

$SystemInfo = Get-SystemInfo

Write-Host "Computer Name     :" $SystemInfo.ComputerName
Write-Host "User Name         :" $SystemInfo.UserName
Write-Host "User Domain       :" $SystemInfo.UserDomain
Write-Host "Operating System  :" $SystemInfo.OperatingSystem
Write-Host "OS Version        :" $SystemInfo.OSVersion
Write-Host "Architecture      :" $SystemInfo.Architecture
Write-Host "PowerShell        :" $SystemInfo.PowerShellVersion

Write-Host ""
Write-Host "System information collected successfully."