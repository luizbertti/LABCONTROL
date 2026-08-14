# ==============================================================================
# Script: OnLogon.ps1
# Description: Tarefa executada ao fazer logon do Windows.
# ==============================================================================

# 1. IMPORTAR AS FERRAMENTAS DO SISTEMA (Isso resolve o erro do Write-Log)
. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando tarefa agendada: OnLogon (Inicio de Sessao)." -Level "INFO"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       INICIANDO ROTINA DE LOGON        " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ==============================================================================
# FILTRO WEB (Libera apenas se for o Administrador)
# ==============================================================================
# Pega o usuario real
$currentUser = $env:USERNAME

Write-Log -Message "Filtro Web: Verificando acesso para o usuario -> [$currentUser]" -Level "INFO"
Write-Host "`n-> Verificando acesso a internet para: $currentUser" -ForegroundColor Cyan

# ⚠️ NOME DO SEU USUARIO ADMINISTRADOR (Deixe tudo em letras minúsculas)
$adminNames = @("luiz", "administrador", "admin", "professor")

if ($currentUser.ToLower() -in $adminNames) {
    Write-Host "  -> Bem-vindo, Professor! Removendo bloqueios de internet..." -ForegroundColor Yellow
    Write-Log -Message "Filtro Web: Usuario Admin ($currentUser) reconhecido. Destrancando." -Level "INFO"
    
    $edgeGlobal = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist"
    $chromeGlobal = "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist"
    
    if (Test-Path $edgeGlobal) { Remove-Item -Path $edgeGlobal -Recurse -Force | Out-Null }
    if (Test-Path $chromeGlobal) { Remove-Item -Path $chromeGlobal -Recurse -Force | Out-Null }
} else {
    Write-Host "  -> Usuario padrao detectado ($currentUser). Mantendo bloqueios ativos." -ForegroundColor Green
    Write-Log -Message "Filtro Web: Usuario padrao ($currentUser) detectado. Mantendo trancado." -Level "INFO"
}

Write-Log -Message "Tarefa OnLogon finalizada com sucesso." -Level "INFO"
Write-Host "`n[ OK ] Tarefa OnLogon concluida." -ForegroundColor Green