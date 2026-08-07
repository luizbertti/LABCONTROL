# ============================================================
# LABCONTROL
# Edge Launcher
# ============================================================

Set-StrictMode -Version Latest

# Load Core modules
. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"
. "$PSScriptRoot\..\Core\Browser.ps1"
. "$PSScriptRoot\..\Core\Profile.ps1"

# Initialize LABCONTROL
Initialize-LabControl

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL EDGE LAUNCHER"
Write-Host "========================================"
Write-Host ""

try {

    if (Test-BrowserRunning -Browser "Edge") {
        throw "Edge is already running."
    }

    $ProfileStatus = Test-Profile -Browser "Edge"

    if (-not $ProfileStatus.Template) {
        throw "Edge profile template not found."
    }

    Write-Host "Restoring Edge profile..."

    Restore-Profile -Browser "Edge" | Out-Null

    Write-Host "[ OK ] Profile restored."
    Write-Host ""

    Write-Host "Starting Edge..."

    $Started = Start-Browser -Browser "Edge"

    if (-not $Started) {
        throw "Edge failed to start."
    }

    Write-Log `
        -Level "INFO" `
        -Message "Edge launched successfully."

    Write-Host "[ OK ] Edge started."
    Write-Host ""

}
catch {

    Write-Host "[FAIL] $($_.Exception.Message)"
    Write-Host ""

    exit 1
}