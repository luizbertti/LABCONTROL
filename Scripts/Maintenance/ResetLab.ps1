# ==============================================================================
# Script: ResetLab.ps1
# Description: Executa todas as rotinas de limpeza de manutenção do laboratório em lote.
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando rotina consolidada: ResetLab." -Level "INFO"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     INICIANDO LIMPEZA GERAL DO LAB     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Lista de scripts de manutenção a serem executados
$scriptsToRun = @(
    "$PSScriptRoot\ClearDownloads.ps1",
    "$PSScriptRoot\ClearTemp.ps1"
)

foreach ($script in $scriptsToRun) {
    if (Test-Path -Path $script) {
        Write-Host "`n-> Executando: $(Split-Path $script -Leaf)" -ForegroundColor Cyan
        try {
            # O operador '&' executa o script referenciado no caminho
            & $script
        }
        catch {
            Write-Log -Message "Erro ao executar $($script): $($_.Exception.Message)" -Level "ERROR"
            Write-Host "[FAIL] Falha ao executar $(Split-Path $script -Leaf)." -ForegroundColor Red
        }
    }
    else {
        Write-Log -Message "Script não encontrado: $script" -Level "WARNING"
        Write-Host "[SKIP] Script não encontrado: $(Split-Path $script -Leaf)" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "         LIMPEZA GERAL CONCLUIDA        " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Log -Message "Rotina consolidada ResetLab finalizada." -Level "INFO"