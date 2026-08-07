# Carrega o módulo de validação
. "$PSScriptRoot\..\Core\Validation.ps1"

$result = Test-LabEnvironment

Write-Host ""
Write-Host "Validation Result: $result"