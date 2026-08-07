# ==============================================================================
# Script: OnLogon.ps1
# Description: Tarefa executada ao fazer logon no Windows (Início de Sessão).
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando tarefa agendada: OnLogon (Inicio de Sessao)." -Level "INFO"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        INICIANDO PREPARACAO DE LOGON   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Reset dos Navegadores (Garantia contra desligamento forçado)
$resetBrowserScript = "$PSScriptRoot\ResetBrowser.ps1"

if (Test-Path -Path $resetBrowserScript) {
    Write-Host "`n-> Garantindo navegadores limpos..." -ForegroundColor Cyan
    try {
        & $resetBrowserScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetBrowser no Logon: $($_.Exception.Message)" -Level "ERROR"
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
    Write-Host "`n-> Garantindo limpeza de arquivos locais (Downloads/Temp)..." -ForegroundColor Cyan
    try {
        & $resetLabScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetLab no Logon: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao limpar arquivos locais." -ForegroundColor Red
    }
}
else {
    Write-Log -Message "Script ResetLab não encontrado em $resetLabScript" -Level "WARNING"
    Write-Host "[SKIP] Script ResetLab não localizado." -ForegroundColor Yellow
}

Write-Log -Message "Tarefa OnLogon finalizada com sucesso." -Level "INFO"
Write-Host "`n[ OK ] Tarefa OnLogon concluida." -ForegroundColor Green