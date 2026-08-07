# ============================================================
# LABCONTROL
# Validation Module
# ============================================================

Set-StrictMode -Version Latest

. "$PSScriptRoot\Config.ps1"

function Test-Directory {

    param(
        [string]$Path
    )

    return (Test-Path $Path -PathType Container)

}

function Test-LabEnvironment {

    Initialize-LabControl

    $Config = Get-LabConfig

    $Checks = @(
        @{
            Name = "Backup folder"
            Path = $Config.Paths.Backup
        },
        @{
            Name = "Config folder"
            Path = $Config.Paths.Config
        },
        @{
            Name = "Logs folder"
            Path = $Config.Paths.Logs
        },
        @{
            Name = "Runtime folder"
            Path = $Config.Paths.Runtime
        },
        @{
            Name = "Templates folder"
            Path = $Config.Paths.Templates
        },
        @{
            Name = "Temp folder"
            Path = $Config.Paths.Temp
        }
    )

    Write-Host ""
    Write-Host "========================================"
    Write-Host " LABCONTROL ENVIRONMENT VALIDATION"
    Write-Host "========================================"
    Write-Host ""

    foreach ($Check in $Checks) {

        if (Test-Directory $Check.Path) {

            Write-Host ("[ OK ] {0}" -f $Check.Name)

        }
        else {

            Write-Host ("[FAIL] {0}" -f $Check.Name)
            Write-Host ("       Expected: {0}" -f $Check.Path)

            return $false

        }

    }

    Write-Host ""
    Write-Host "Environment validation completed successfully."

    return $true

}