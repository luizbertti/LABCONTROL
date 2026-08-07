# ============================================================
# LABCONTROL
# On Unlock Task
# ============================================================

Set-StrictMode -Version Latest


# ------------------------------------------------------------
# Load Core modules
# ------------------------------------------------------------

# Correção dos caminhos para voltar apenas 1 nível até a pasta Scripts
. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"
. "$PSScriptRoot\..\Core\Browser.ps1"
. "$PSScriptRoot\..\Core\Profile.ps1"


# ------------------------------------------------------------
# Initialize LABCONTROL
# ------------------------------------------------------------

Initialize-LabControl


# ------------------------------------------------------------
# Task information
# ------------------------------------------------------------

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL ON UNLOCK"
Write-Host "========================================"
Write-Host ""

Write-Log `
    -Level "INFO" `
    -Message "OnUnlock task started."


# ------------------------------------------------------------
# Process browsers
# ------------------------------------------------------------

$Browsers = @(
    "Chrome",
    "Edge"
)

foreach ($Browser in $Browsers) {

    Write-Host "Checking $Browser..."

    try {

        # ----------------------------------------------------
        # Check browser state
        # ----------------------------------------------------

        if (Test-BrowserRunning -Browser $Browser) {

            Write-Host "[SKIP] $Browser is currently running."

            Write-Log `
                -Level "WARNING" `
                -Message "$Browser is currently running during OnUnlock."

            continue
        }


        # ----------------------------------------------------
        # Restore profile
        # ----------------------------------------------------

        Write-Host "Restoring $Browser profile..."

        $Result = Restore-Profile -Browser $Browser

        if (-not $Result) {

            Write-Host "[FAIL] $Browser profile restoration failed."

            Write-Log `
                -Level "ERROR" `
                -Message "$Browser profile restoration failed during OnUnlock."

            continue
        }


        Write-Host "[ OK ] $Browser profile restored."

        Write-Log `
            -Level "INFO" `
            -Message "$Browser profile restored during OnUnlock."

    }
    catch {

        Write-Host "[FAIL] $Browser - $($_.Exception.Message)"

        Write-Log `
            -Level "ERROR" `
            -Message "OnUnlock failed for $Browser : $($_.Exception.Message)"
    }
}


# ------------------------------------------------------------
# Completion
# ------------------------------------------------------------

Write-Log `
    -Level "INFO" `
    -Message "OnUnlock task completed."

Write-Host ""
Write-Host "OnUnlock task completed."
Write-Host ""