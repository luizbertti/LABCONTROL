# ==============================================================================
# Script: DailyCleanup.ps1
# Description: Tarefa diária para limpeza profunda e rotação de logs.
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando tarefa agendada: Limpeza Diária (Daily Cleanup)." -Level "INFO"

# 1. Executa o ResetLab (Limpeza de Downloads e Temp)
$resetLabScript = "$PSScriptRoot\..\Maintenance\ResetLab.ps1"

Write-Host "Iniciando verificação diária de sistema..." -ForegroundColor Cyan

if (Test-Path -Path $resetLabScript) {
    # Executa o script de manutenção consolidada
    & $resetLabScript
}
else {
    Write-Log -Message "Script ResetLab não encontrado em $resetLabScript" -Level "WARNING"
    Write-Host "[WARN] Script ResetLab.ps1 não localizado." -ForegroundColor Yellow
}

# 2. Limpeza de Logs Antigos (Manutenção do LABCONTROL)
$logPath = "C:\LABCONTROL_DATA\Logs"
$diasRetencao = 15

if (Test-Path -Path $logPath) {
    Write-Host "Verificando logs antigos (mais de $($diasRetencao) dias)..."
    try {
        # Busca logs com a data de modificação mais antiga que 15 dias atrás
        $logsAntigos = Get-ChildItem -Path $logPath -Filter "*.log" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$diasRetencao) }
        
        if ($logsAntigos) {
            $logsAntigos | Remove-Item -Force -ErrorAction Stop
            Write-Log -Message "Logs com mais de $($diasRetencao) dias foram removidos." -Level "INFO"
            Write-Host "[ OK ] Rotação de logs concluída. Arquivos antigos removidos." -ForegroundColor Green
        }
        else {
            Write-Host "[ OK ] Nenhum log antigo para remover no momento." -ForegroundColor Green
        }
    }
    catch {
        Write-Log -Message "Erro ao limpar logs: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao rotacionar logs antigos." -ForegroundColor Red
    }
}
else {
    Write-Host "[SKIP] Diretório de logs não encontrado." -ForegroundColor Yellow
}

Write-Log -Message "Tarefa Limpeza Diária finalizada com sucesso." -Level "INFO"