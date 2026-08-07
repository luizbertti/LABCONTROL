# ============================================================
# LABCONTROL
# Browser Reset Task Test
# ============================================================

Set-StrictMode -Version Latest

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL RESET TASK TEST"
Write-Host "========================================"
Write-Host ""

$Browser = "Edge"

Write-Host "Browser:" $Browser
Write-Host ""

& "$PSScriptRoot\..\Tasks\ResetBrowser.ps1" -Browser $Browser