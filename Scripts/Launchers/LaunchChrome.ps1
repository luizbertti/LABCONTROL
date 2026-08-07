# ============================================================
# LABCONTROL
# Chrome Launcher
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
Write-Host " LABCONTROL CHROME LAUNCHER"
Write-Host "========================================"
Write-Host ""

try {

    if (Test-BrowserRunning -Browser "Chrome") {
        throw "Chrome is already running."
    }

    $ProfileStatus = Test-Profile -Browser "Chrome"

    if (-not $ProfileStatus.Template) {
        throw "Chrome profile template not found."
    }

    Write-Host "Restoring Chrome profile..."

    Restore-Profile -Browser "Chrome" | Out-Null

    Write-Host "[ OK ] Profile restored."
    Write-Host ""

    Write-Host "Starting Chrome..."

    $Started = Start-Browser -Browser "Chrome"

    if (-not $Started) {
        throw "Chrome failed to start."
    }

    Write-Log `
        -Level "INFO" `
        -Message "Chrome launched successfully."

    Write-Host "[ OK ] Chrome started."
    Write-Host ""

}
catch {

    Write-Host "[FAIL] $($_.Exception.Message)"
    Write-Host ""

    exit 1
}