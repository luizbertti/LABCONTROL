# ==============================================================================
# Script: CreateShortcuts.ps1
# Description: Cria atalhos na Area de Trabalho e "sequestra" os do Menu Iniciar.
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       CONFIGURANDO ATALHOS DO LAB      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$wshShell = New-Object -ComObject WScript.Shell

# 1. Caminho da Area de Trabalho
$desktopPath = [Environment]::GetFolderPath('Desktop')

# 2. Caminhos do Menu Iniciar (Publico/Todos os Usuarios e Usuario Atual)
$startMenuAll = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
$startMenuUser = [Environment]::GetFolderPath('Programs')

# Mapeamento com as rotas alvo para o sequestro
$shortcuts = @(
    @{
        Name = "Google Chrome";
        Script = "$PSScriptRoot\..\Launchers\LaunchChrome.ps1";
        Icon = "C:\Program Files\Google\Chrome\Application\chrome.exe";
        TargetPaths = @(
            "$desktopPath\Google Chrome.lnk",
            "$startMenuAll\Google Chrome.lnk",
            "$startMenuUser\Google Chrome.lnk"
        )
    },
    @{
        Name = "Microsoft Edge";
        Script = "$PSScriptRoot\..\Launchers\LaunchEdge.ps1";
        Icon = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
        TargetPaths = @(
            "$desktopPath\Microsoft Edge.lnk",
            "$startMenuAll\Microsoft Edge.lnk",
            "$startMenuUser\Microsoft Edge.lnk"
        )
    }
)

foreach ($shortcut in $shortcuts) {
    Write-Host "`n-> Injetando Launcher no: $($shortcut.Name)"
    
    foreach ($lnkPath in $shortcut.TargetPaths) {
        try {
            $shortcutItem = $wshShell.CreateShortcut($lnkPath)
            
            # O atalho é forcado a rodar o nosso script silencioso
            $shortcutItem.TargetPath = "powershell.exe"
            $shortcutItem.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$($shortcut.Script)`""
            
            # Mantemos o icone original para o aluno nao desconfiar
            if (Test-Path $shortcut.Icon) {
                $shortcutItem.IconLocation = "$($shortcut.Icon), 0"
            }
            
            $shortcutItem.Save()
            Write-Host "  [ OK ] Atalho injetado: $lnkPath" -ForegroundColor Green
        }
        catch {
            Write-Host "  [SKIP] Nao foi possivel modificar: $lnkPath" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   ATALHOS SEQUESTRADOS COM SUCESSO     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan