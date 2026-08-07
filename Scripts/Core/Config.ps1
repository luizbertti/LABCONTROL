function Initialize-LabControl {

    $configFolder = Join-Path $PSScriptRoot "..\..\Config"

    $labFile     = Join-Path $configFolder "LabControl.json"
    $chromeFile  = Join-Path $configFolder "Chrome.json"
    $edgeFile    = Join-Path $configFolder "Edge.json"
    $versionFile = Join-Path $configFolder "Version.json"

    foreach ($file in @($labFile, $chromeFile, $edgeFile, $versionFile)) {

        if (-not (Test-Path $file)) {
            throw "Configuration file not found: $file"
        }

    }

    $script:LabControl = @{

        Config  = Get-Content $labFile -Raw | ConvertFrom-Json
        Chrome  = Get-Content $chromeFile -Raw | ConvertFrom-Json
        Edge    = Get-Content $edgeFile -Raw | ConvertFrom-Json
        Version = Get-Content $versionFile -Raw | ConvertFrom-Json

    }

}
function Get-LabConfig {

    return $Global:LabControl.Config

}

function Get-ChromeConfig {

    return $Global:LabControl.Chrome

}

function Get-EdgeConfig {

    return $Global:LabControl.Edge

}

function Get-Version {

    return $Global:LabControl.Version

}