# ============================================================
# LABCONTROL
# Profile Module
# ============================================================

Set-StrictMode -Version Latest


function Get-ProfileTemplate {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    switch ($Browser) {

        "Chrome" {
            return (Get-ChromeConfig).Profile.Template
        }

        "Edge" {
            return (Get-EdgeConfig).Profile.Template
        }

    }
}


function Get-ProfileRuntime {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    switch ($Browser) {

        "Chrome" {
            return (Get-ChromeConfig).Profile.Runtime
        }

        "Edge" {
            return (Get-EdgeConfig).Profile.Runtime
        }

    }
}


function Test-Profile {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    $Template = Get-ProfileTemplate -Browser $Browser

    $Runtime = Get-ProfileRuntime -Browser $Browser

    $TemplateExists = Test-Path $Template -PathType Container
    $RuntimeExists = Test-Path $Runtime -PathType Container

    return @{
        Template = $TemplateExists
        Runtime = $RuntimeExists
    }
}

function Test-ProfileInUse {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    switch ($Browser) {

        "Chrome" {
            $ProcessName = "chrome"
        }

        "Edge" {
            $ProcessName = "msedge"
        }

    }

    $Processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue

    return ($null -ne $Processes)
}

function Clear-ProfileRuntime {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    if (Test-ProfileInUse -Browser $Browser) {

        throw "$Browser is currently running. Close the browser before clearing the profile."

    }

    $Runtime = Get-ProfileRuntime -Browser $Browser

    if (-not (Test-Path $Runtime -PathType Container)) {

        New-Item -ItemType Directory -Path $Runtime -Force | Out-Null

        return $true

    }

    Remove-Item -Path $Runtime -Recurse -Force

    New-Item -ItemType Directory -Path $Runtime -Force | Out-Null

    return $true
}

function Restore-Profile {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    $Template = Get-ProfileTemplate -Browser $Browser
    $Runtime = Get-ProfileRuntime -Browser $Browser

    if (-not (Test-Path $Template -PathType Container)) {
        throw "Profile template not found: $Template"
    }

    Clear-ProfileRuntime -Browser $Browser

    New-Item -ItemType Directory -Path $Runtime -Force | Out-Null

    Copy-Item `
        -Path (Join-Path $Template "*") `
        -Destination $Runtime `
        -Recurse `
        -Force

    return $true
}