# ==============================================================================
# Script: CreateAdminShortcuts.ps1
# Description: Cria os atalhos originais (Backdoors) na pasta segura do Professor.
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      CRIANDO FERRAMENTAS DO ADMIN      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$wshShell = New-Object -ComObject WScript.Shell

# Cria a pasta 'AdminTools' dentro da raiz do LABCONTROL, longe da Área de Trabalho
$adminToolsPath = "$PSScriptRoot\..\..\AdminTools"
if (-not (Test-Path $adminToolsPath)) {
    New-Item -Path $adminToolsPath -ItemType Directory | Out-Null
    Write-Host "-> Pasta AdminTools criada com sucesso."
}

$adminShortcuts = @(
    @{
        Name = "RealC";
        TargetPath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    },
    @{
        Name = "RealE";
        TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    }
)

foreach ($shortcut in $adminShortcuts) {
    $lnkPath = "$adminToolsPath\$($shortcut.Name).lnk"
    
    if (Test-Path $shortcut.TargetPath) {
        try {
            $shortcutItem = $wshShell.CreateShortcut($lnkPath)
            
            # Aponta DIRETAMENTE para o executavel original, sem scripts no meio
            $shortcutItem.TargetPath = $shortcut.TargetPath
            $shortcutItem.Save()
            
            Write-Host "[ OK ] Atalho seguro criado: $lnkPath" -ForegroundColor Green
        }
        catch {
            Write-Host "[FAIL] Erro ao criar $($shortcut.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "[SKIP] Navegador nao encontrado: $($shortcut.TargetPath)" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "         COFRE ADMIN CONFIGURADO        " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan