# ==============================================================================
# Script: InstallLab.ps1
# Description: Script mestre de instalação do LABCONTROL em uma nova máquina.
# ==============================================================================

# Exige privilégios de Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[FAIL] A instalacao exige privilegios de Administrador!" -ForegroundColor Red
    Write-Host "Feche o terminal/PowerShell, abra-o novamente como Administrador e execute este script." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    return
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      INICIANDO INSTALACAO DO LAB       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Libera o Windows para rodar scripts (Essencial para máquinas recém-formatadas)
Write-Host "`n-> Configurando permissões do PowerShell..." -ForegroundColor Cyan
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Lista dos scripts de instalação na ordem correta
$scriptsToRun = @(
    "$PSScriptRoot\CreateFolders.ps1",
    "$PSScriptRoot\OptimizeBrowsers.ps1",
    "$PSScriptRoot\WebFilter.ps1",
    "$PSScriptRoot\LockSystem.ps1",
    "$PSScriptRoot\BlockExecutables.ps1",
    "$PSScriptRoot\CreateShortcuts.ps1",
    "$PSScriptRoot\..\Maintenance\UpdateControl.ps1", # <- Nossa nova blindagem do Windows Update
    "$PSScriptRoot\RegisterTask.ps1"
)

foreach ($script in $scriptsToRun) {
    if (Test-Path -Path $script) {
        Write-Host "`n-> Executando fase de instalacao: $(Split-Path $script -Leaf)" -ForegroundColor Cyan
        try {
            & $script
        }
        catch {
            Write-Host "[FAIL] Falha ao executar $(Split-Path $script -Leaf): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[SKIP] Script não encontrado: $(Split-Path $script -Leaf)" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   INSTALACAO DO LABCONTROL CONCLUIDA   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "A maquina esta pronta para o uso dos alunos." -ForegroundColor Green
Start-Sleep -Seconds 5