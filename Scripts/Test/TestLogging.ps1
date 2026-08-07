# Load configuration
. "$PSScriptRoot\..\Core\Config.ps1"

# Load logging module
. "$PSScriptRoot\..\Core\Logging.ps1"

# Initialize configuration
Initialize-LabControl

Write-Host ""
Write-Host "========================================"
Write-Host " LABCONTROL LOGGING TEST"
Write-Host "========================================"
Write-Host ""

Write-Log -Level "INFO" -Message "Information test."
Write-Log -Level "WARNING" -Message "Warning test."
Write-Log -Level "ERROR" -Message "Error test."
Write-Log -Level "DEBUG" -Message "Debug test."

Write-Host "Log entries created."
Write-Host ""

$LogFile = (Get-LabConfig).Logging.File

Write-Host "Log file:"
Write-Host $LogFile