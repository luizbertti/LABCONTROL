# ==============================================================================
# Script: CreateShortcuts.ps1
# Description: Cria atalhos na Área de Trabalho apontando para os Launchers.
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       CRIANDO ATALHOS DO SISTEMA       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Objeto COM do Windows para manipulação de atalhos
$wshShell = New-Object -ComObject WScript.Shell

# Define a Área de Trabalho do usuário atual
$desktopPath = [Environment]::GetFolderPath('Desktop')

# Mapeamento dos atalhos que apontam para a pasta Launchers
$shortcuts = @(
    @{
        Name = "Google Chrome";
        Script = "$PSScriptRoot\..\Launchers\LaunchChrome.ps1";
        Icon = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    },
    @{
        Name = "Microsoft Edge";
        Script = "$PSScriptRoot\..\Launchers\LaunchEdge.ps1";
        Icon = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    }
)

foreach ($shortcut in $shortcuts) {
    $lnkPath = Join-Path -Path $desktopPath -ChildPath "$($shortcut.Name).lnk"
    
    Write-Host "Configurando atalho: $($shortcut.Name)"
    
    try {
        $shortcutItem = $wshShell.CreateShortcut($lnkPath)
        
        # O atalho executa o PowerShell chamando o script de forma oculta
        $shortcutItem.TargetPath = "powershell.exe"
        $shortcutItem.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$($shortcut.Script)`""
        
        # Injeta o ícone original do navegador se o executável padrão existir na máquina
        if (Test-Path $shortcut.Icon) {
            $shortcutItem.IconLocation = "$($shortcut.Icon), 0"
        }
        
        $shortcutItem.Save()
        Write-Host "[ OK ] Atalho criado: $lnkPath" -ForegroundColor Green
    }
    catch {
        Write-Host "[FAIL] Erro ao criar atalho $($shortcut.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "      ATALHOS CRIADOS COM SUCESSO       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan