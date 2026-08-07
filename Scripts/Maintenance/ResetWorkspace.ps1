# ==============================================================================
# Script: ResetWorkspace.ps1
# Description: Reseta o Papel de Parede e limpa pastas de usuário (com Whitelist no Desktop).
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     INICIANDO LIMPEZA DE WORKSPACE     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# 1. Reset do Papel de Parede (Wallpaper)
# ------------------------------------------------------------------------------
$defaultWallpaper = "C:\Windows\Web\Wallpaper\Windows\img0.jpg" 

if (Test-Path $defaultWallpaper) {
    Write-Host "-> Resetando Papel de Parede..."
    try {
        $setWallCode = @'
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet=CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
'@
        if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
            Add-Type -TypeDefinition $setWallCode
        }
        
        [Wallpaper]::SystemParametersInfo(0x0014, 0, $defaultWallpaper, 3) | Out-Null
        Write-Host "[ OK ] Papel de parede restaurado." -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] Erro ao resetar papel de parede: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ------------------------------------------------------------------------------
# 2. Limpeza de Pastas de Usuário
# ------------------------------------------------------------------------------
$foldersToClean = @(
    [Environment]::GetFolderPath('MyDocuments'),
    [Environment]::GetFolderPath('MyPictures'),
    [Environment]::GetFolderPath('MyVideos'),
    [Environment]::GetFolderPath('MyMusic'),
    "$env:USERPROFILE\Downloads"
)

Write-Host "`n-> Limpando Arquivos Pessoais do Usuário..."
foreach ($folder in $foldersToClean) {
    if (Test-Path $folder) {
        try {
            Get-ChildItem -Path $folder -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "[ OK ] $folder" -ForegroundColor Green
        } catch {
            Write-Host "[FAIL] Erro ao limpar $folder" -ForegroundColor Red
        }
    }
}

# ------------------------------------------------------------------------------
# 3. Limpeza da Area de Trabalho (Com Whitelist Inteligente)
# ------------------------------------------------------------------------------
$desktopPath = [Environment]::GetFolderPath('Desktop')

# Whitelist baseada na imagem (agora totalmente segura contra caracteres especiais)
$whitelistPatterns = @(
    "Google Chrome", "Microsoft Edge", "Firefox",
    "Free Pascal", "Visual Studio Code", "Figma", "Sublime Text",
    "Unity Hub", "Android Studio", "NetBeans", "LibreOffice",
    "Scratch", "Atom", "PyCharm", "Lua", "Audacity", 
    "XAMPP", "VirtualBox", "LOVE", "GIMP", "Blender", 
    "MySQL Workbench", "Geany", "Git Bash", "Packet Tracer", 
    "Kdenlive", "filtroweb", "SciTE", "mBlock", "Inkscape", 
    "Calculator", "Acrobat", "Lazarus", "mLink", "MuseScore", "Notepad++"
)

Write-Host "`n-> Limpando Area de Trabalho (Protegendo Whitelist)..."
if (Test-Path $desktopPath) {
    try {
        $desktopItems = Get-ChildItem -Path $desktopPath -Force
        $removidos = 0

        foreach ($item in $desktopItems) {
            $manter = $false
            
            # CORREÇÃO AQUI: Usando -like com asteriscos para ignorar Regex
            foreach ($pattern in $whitelistPatterns) {
                if ($item.Name -like "*$pattern*") {
                    $manter = $true
                    break
                }
            }

            if ($item.Extension -eq ".ini") { $manter = $true }

            if (-not $manter) {
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "  [X] Removido: $($item.Name)" -ForegroundColor Yellow
                $removidos++
            }
        }
        
        Write-Host "[ OK ] Area de Trabalho verificada ($removidos itens indesejados removidos)." -ForegroundColor Green
    } catch {
        # Adicionei a mensagem de erro detalhada para não ficarmos cegos se falhar novamente
        Write-Host "[FAIL] Erro ao processar Area de Trabalho: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "      WORKSPACE LIMPO COM SUCESSO       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan