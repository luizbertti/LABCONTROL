# ============================================================
# LABCONTROL
# Core Integration Test
# ============================================================

Set-StrictMode -Version Latest

# Load Core modules
. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Validation.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"
. "$PSScriptRoot\..\Core\System.ps1"
. "$PSScriptRoot\..\Core\Profile.ps1"
. "$PSScriptRoot\..\Core\Browser.ps1"

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL CORE INTEGRATION TEST"
Write-Host "========================================"
Write-Host ""

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

Write-Host "[1] Initializing configuration..."

Initialize-LabControl

Write-Host "[ OK ] Configuration loaded."
Write-Host ""

# ------------------------------------------------------------
# Environment validation
# ------------------------------------------------------------

Write-Host "[2] Validating environment..."

$ValidationResult = Test-LabEnvironment

if (-not $ValidationResult) {
    throw "Environment validation failed."
}

Write-Host "[ OK ] Environment validated."
Write-Host ""

# ------------------------------------------------------------
# System
# ------------------------------------------------------------

Write-Host "[3] Reading system information..."

$SystemInfo = Get-SystemInfo

Write-Host "[ OK ] Computer:" $SystemInfo.ComputerName
Write-Host "[ OK ] Operating System:" $SystemInfo.OperatingSystem
Write-Host ""

# ------------------------------------------------------------
# Logging
# ------------------------------------------------------------

Write-Host "[4] Testing logging..."

Write-Log `
    -Level "INFO" `
    -Message "Core integration test started."

Write-Host "[ OK ] Logging operational."
Write-Host ""

# ------------------------------------------------------------
# Browser detection
# ------------------------------------------------------------

Write-Host "[5] Checking browsers..."

foreach ($Browser in @("Chrome", "Edge")) {

    if (Test-BrowserInstalled -Browser $Browser) {

        Write-Host "[ OK ] $Browser installed."

    }
    else {

        Write-Host "[FAIL] $Browser not installed."

    }
}

Write-Host ""

# ------------------------------------------------------------
# Profile detection
# ------------------------------------------------------------

Write-Host "[6] Checking profiles..."

foreach ($Browser in @("Chrome", "Edge")) {

    $ProfileStatus = Test-Profile -Browser $Browser

    if ($ProfileStatus.Template) {
        Write-Host "[ OK ] $Browser template."
    }
    else {
        Write-Host "[FAIL] $Browser template."
    }

    if ($ProfileStatus.Runtime) {
        Write-Host "[ OK ] $Browser runtime."
    }
    else {
        Write-Host "[FAIL] $Browser runtime."
    }
}

Write-Host ""

# ------------------------------------------------------------
# Finish
# ------------------------------------------------------------

Write-Log `
    -Level "INFO" `
    -Message "Core integration test completed successfully."

Write-Host "========================================"
Write-Host " CORE TEST COMPLETED"
Write-Host "========================================"