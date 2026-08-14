# ==============================================================================
# Script: OnLogoff.ps1
# Description: Tarefa executada ao fazer logoff do Windows para limpeza profunda.
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando tarefa agendada: OnLogoff (Encerramento de Sessão)." -Level "INFO"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        INICIANDO LIMPEZA DE LOGOFF     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Reset dos Navegadores (utiliza o script dedicado da pasta Tasks)
$resetBrowserScript = "$PSScriptRoot\ResetBrowser.ps1"

if (Test-Path -Path $resetBrowserScript) {
    Write-Host "`n-> Resetando Navegadores..." -ForegroundColor Cyan
    try {
        & $resetBrowserScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetBrowser no Logoff: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao resetar navegadores." -ForegroundColor Red
    }
}
else {
    Write-Log -Message "Script ResetBrowser não encontrado em $resetBrowserScript" -Level "WARNING"
    Write-Host "[SKIP] Script ResetBrowser não localizado." -ForegroundColor Yellow
}

# 2. Limpeza Geral (Downloads e Temp via ResetLab)
$resetLabScript = "$PSScriptRoot\..\Maintenance\ResetLab.ps1"

if (Test-Path -Path $resetLabScript) {
    Write-Host "`n-> Limpando Arquivos Locais (Downloads/Temp)..." -ForegroundColor Cyan
    try {
        & $resetLabScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetLab no Logoff: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao limpar arquivos locais." -ForegroundColor Red
    }
}
else {
    Write-Log -Message "Script ResetLab não encontrado em $resetLabScript" -Level "WARNING"
    Write-Host "[SKIP] Script ResetLab não localizado." -ForegroundColor Yellow
}

# 3. Limpeza do Workspace (Papel de Parede e Pastas)
$resetWorkspaceScript = "$PSScriptRoot\..\Maintenance\ResetWorkspace.ps1"

if (Test-Path -Path $resetWorkspaceScript) {
    Write-Host "`n-> Limpando Workspace (Pastas e Papel de Parede)..." -ForegroundColor Cyan
    try {
        & $resetWorkspaceScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetWorkspace no Logoff: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao limpar o Workspace." -ForegroundColor Red
    }
}
else {
    Write-Log -Message "Script ResetWorkspace não encontrado em $resetWorkspaceScript" -Level "WARNING"
    Write-Host "[SKIP] Script ResetWorkspace não localizado." -ForegroundColor Yellow
}

# ==============================================================================
# NOVA PARTE ADICIONADA: 4. Restauração do Filtro Web (Bloqueio)
# ==============================================================================
Write-Host "`n-> Restaurando bloqueios de internet para a proxima sessao..." -ForegroundColor Cyan

try {
    $blockedSites = @(
        "poki.com", "roblox.com", "clickjogos.com.br", "friv.com",
        "crazygames.com", "kizi.com", "ojogos.com.br", "now.gg",
        "discord.com", "web.whatsapp.com", "instagram.com", "tiktok.com",
        "twitter.com", "x.com", "twitch.tv",
        "croxyproxy.com", "blockaway.net", "proxysite.com", "hide.me"
    )

    $edgeGlobal = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist"
    $chromeGlobal = "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist"

    if (-not (Test-Path $edgeGlobal)) { New-Item -Path $edgeGlobal -Force | Out-Null }
    if (-not (Test-Path $chromeGlobal)) { New-Item -Path $chromeGlobal -Force | Out-Null }

    $index = 1
    foreach ($site in $blockedSites) {
        Set-ItemProperty -Path $edgeGlobal -Name $index.ToString() -Value $site -Type String
        Set-ItemProperty -Path $chromeGlobal -Name $index.ToString() -Value $site -Type String
        $index++
    }
    
    Write-Log -Message "Filtro Web restaurado e trancado com sucesso." -Level "INFO"
    Write-Host "  [ OK ] Filtro Web trancado com sucesso." -ForegroundColor Green
}
catch {
    Write-Log -Message "Erro ao restaurar Filtro Web no Logoff: $($_.Exception.Message)" -Level "ERROR"
    Write-Host "  [FAIL] Falha ao trancar o Filtro Web." -ForegroundColor Red
}
# ==============================================================================

Write-Log -Message "Tarefa OnLogoff finalizada com sucesso." -Level "INFO"
Write-Host "`n[ OK ] Tarefa OnLogoff concluída." -ForegroundColor Green