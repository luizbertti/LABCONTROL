# ============================================================
# LABCONTROL
# Logging Module
# ============================================================

Set-StrictMode -Version Latest

function Write-Log {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("INFO", "WARNING", "ERROR", "DEBUG")]
        [string]$Level,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $Config = Get-LabConfig

    if (-not $Config.Logging.Enabled) {
        return
    }

    $LogFile = $Config.Logging.File

    $LogDirectory = Split-Path $LogFile -Parent

    if (-not (Test-Path $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
    }

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $Entry = "{0} [{1,-7}] {2}" -f $Timestamp, $Level, $Message

    Add-Content -Path $LogFile -Value $Entry
}