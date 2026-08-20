# ==============================================================================
# Script: AutoShutdown.ps1
# Description: Inicia o desligamento automatico da maquina com aviso prévio
# ==============================================================================

Write-Host "Iniciando rotina de desligamento automatico..." -ForegroundColor Cyan

# shutdown.exe -s (desligar) -f (forçar fechamento) -t 300 (esperar 5 min)
$Mensagem = "Fim da aula! Este computador será desligado automaticamente em 5 minutos. Salve seus projetos ou documentos agora!"

try {
    shutdown.exe -s -f -t 300 -c $Mensagem
    Write-Host "[ OK ] Comando de desligamento enviado com sucesso!" -ForegroundColor Green
}
catch {
    Write-Host "[ERRO] Falha ao acionar o desligamento: $($_.Exception.Message)" -ForegroundColor Red
}