# ==============================================================================
# Script: LockSystem.ps1
# Description: Oculta o Disco C e protege o sistema contra modificacoes de alunos.
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     APLICANDO BLINDAGEM DO SISTEMA     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$labPath = "$PSScriptRoot\..\.." # Aponta para a raiz do C:\LABCONTROL
$adminsSID = "*S-1-5-32-544" # Grupo nativo de Administradores
$usersSID = "*S-1-5-32-545"  # Grupo nativo de Usuarios Padrao
$systemSID = "SYSTEM"

try {
    Write-Host "-> Protegendo a pasta LABCONTROL (Modo Seguro)..."
    
    # 1. Quebra a heranca do Disco C: (mantendo as regras base)
    & icacls $labPath /inheritance:d /q | Out-Null
    
    # 2. Garante Controle Total absoluto para o Professor/Admin e para o Sistema
    & icacls $labPath /grant "$adminsSID`:(OI)(CI)(F)" /q | Out-Null
    & icacls $labPath /grant "$systemSID`:(OI)(CI)(F)" /q | Out-Null
    
    # 3. Substitui a regra dos Alunos APENAS para Leitura e Execucao (RX)
    # O parametro ":r" substitui regras anteriores sem precisar usar o "Deny"
    & icacls $labPath /grant:r "$usersSID`:(OI)(CI)(RX)" /q | Out-Null
    
    # 4. Oculta a pasta (Usando apenas +h, assim você pode ver se ativar "Itens Ocultos")
    & attrib +h $labPath
    
    Write-Host "  [ OK ] LABCONTROL blindado com sucesso." -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Erro ao blindar LABCONTROL: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Ocultando o Disco C:\ da interface "Este Computador"
try {
    Write-Host "`n-> Ocultando o Disco C:\ do Windows Explorer..."
    
    $explorerPolicy = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    if (-not (Test-Path $explorerPolicy)) { New-Item -Path $explorerPolicy -Force | Out-Null }
    
    # Valor 4 = Ocultar a letra C:
    Set-ItemProperty -Path $explorerPolicy -Name "NoDrives" -Value 4 -Type DWord
    
    Write-Host "  [ OK ] Disco C:\ ocultado." -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Erro ao ocultar Disco C: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "      BLINDAGEM APLICADA COM SUCESSO    " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan