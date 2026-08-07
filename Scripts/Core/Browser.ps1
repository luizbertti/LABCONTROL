# ============================================================
# LABCONTROL
# Browser Module
# ============================================================

Set-StrictMode -Version Latest


function Find-Chrome {

    $Paths = @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )

    foreach ($Path in $Paths) {

        if (Test-Path $Path -PathType Leaf) {
            return $Path
        }

    }

    return $null
}


function Find-Edge {

    $Paths = @(
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
    )

    foreach ($Path in $Paths) {

        if (Test-Path $Path -PathType Leaf) {
            return $Path
        }

    }

    return $null
}


function Test-BrowserInstalled {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    switch ($Browser) {

        "Chrome" {
            return ($null -ne (Find-Chrome))
        }

        "Edge" {
            return ($null -ne (Find-Edge))
        }

    }

}


function Get-BrowserExecutable {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    switch ($Browser) {

        "Chrome" {
            $Executable = Find-Chrome
        }

        "Edge" {
            $Executable = Find-Edge
        }

    }

    if ($null -eq $Executable) {
        throw "$Browser executable was not found."
    }

    return $Executable
}

function Test-BrowserRunning {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    switch ($Browser) {

        "Chrome" {
            return ($null -ne (Get-Process -Name "chrome" -ErrorAction SilentlyContinue))
        }

        "Edge" {
            return ($null -ne (Get-Process -Name "msedge" -ErrorAction SilentlyContinue))
        }

    }
}

function Stop-Browser {

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

    if ($null -eq $Processes) {
        return $true
    }

    $Processes | Stop-Process -Force

    Start-Sleep -Milliseconds 500

    return ($null -eq (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue))
}

function Start-Browser {

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser
    )

    $Executable = Get-BrowserExecutable -Browser $Browser

    $Runtime = Get-ProfileRuntime -Browser $Browser

    if (-not (Test-Path $Runtime -PathType Container)) {
        throw "Browser runtime profile not found: $Runtime"
    }

    $Arguments = "--user-data-dir=`"$Runtime`""

    Start-Process `
        -FilePath $Executable `
        -ArgumentList $Arguments

    Start-Sleep -Milliseconds 1000

    return (Test-BrowserRunning -Browser $Browser)
}