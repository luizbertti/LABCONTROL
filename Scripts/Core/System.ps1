# ============================================================
# LABCONTROL
# System Module
# ============================================================

Set-StrictMode -Version Latest


function Get-SystemInfo {

    return [PSCustomObject]@{

        ComputerName = $env:COMPUTERNAME

        UserName = $env:USERNAME

        UserDomain = $env:USERDOMAIN

        OperatingSystem = (Get-CimInstance Win32_OperatingSystem).Caption

        OSVersion = (Get-CimInstance Win32_OperatingSystem).Version

        Architecture = (Get-CimInstance Win32_OperatingSystem).OSArchitecture

        PowerShellVersion = $PSVersionTable.PSVersion.ToString()

    }
}