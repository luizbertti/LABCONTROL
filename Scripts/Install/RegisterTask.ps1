# ==============================================================================
# Script: RegisterTask.ps1
# Description: Registra as automações do LABCONTROL no Agendador de Tarefas do Windows.
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    REGISTRANDO TAREFAS NO WINDOWS      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Verifica se o script está rodando como Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[FAIL] Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Por favor, feche o VS Code, abra-o novamente como Administrador e tente outra vez." -ForegroundColor Yellow
    return # Para o script sem fechar o seu terminal
}

$taskUser = "SYSTEM" # Executa com os maiores privilégios silenciosamente
$psArgsBase = "-WindowStyle Hidden -ExecutionPolicy Bypass -File"

# 1. Tarefa: Logon (Roda quando a máquina é iniciada)
try {
    Write-Host "Registrando tarefa: LABCONTROL_OnLogon"
    $actionLogon = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "$psArgsBase `"$PSScriptRoot\..\Tasks\OnLogon.ps1`""
    $triggerLogon = New-ScheduledTaskTrigger -AtLogon
    Register-ScheduledTask -TaskName "LABCONTROL_OnLogon" -Action $actionLogon -Trigger $triggerLogon -User $taskUser -RunLevel Highest -Force | Out-Null
    Write-Host "[ OK ] LABCONTROL_OnLogon registrada." -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Erro no OnLogon: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Tarefa: Daily Cleanup (Roda todos os dias às 02:00 da manhã)
try {
    Write-Host "Registrando tarefa: LABCONTROL_DailyCleanup"
    $actionDaily = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "$psArgsBase `"$PSScriptRoot\..\Tasks\DailyCleanup.ps1`""
    $triggerDaily = New-ScheduledTaskTrigger -Daily -At "02:00 AM"
    Register-ScheduledTask -TaskName "LABCONTROL_DailyCleanup" -Action $actionDaily -Trigger $triggerDaily -User $taskUser -RunLevel Highest -Force | Out-Null
    Write-Host "[ OK ] LABCONTROL_DailyCleanup registrada." -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Erro no DailyCleanup: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Tarefa: OnLogoff / Bloqueio de Tela (Injeção via XML nativo)
try {
    Write-Host "Registrando tarefa: LABCONTROL_OnLogoff (Bloqueio de Tela)"
    
    $logoffScript = "$PSScriptRoot\..\Tasks\OnLogoff.ps1"
    
    # Monta o XML que o Agendador de Tarefas lê nativamente (à prova de bugs)
    $taskXml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Triggers>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled>
      <StateChange>SessionLock</StateChange>
    </SessionStateChangeTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>$psArgsBase &quot;$logoffScript&quot;</Arguments>
    </Exec>
  </Actions>
</Task>
"@
    
    Register-ScheduledTask -TaskName "LABCONTROL_OnLogoff" -Xml $taskXml -Force | Out-Null
    Write-Host "[ OK ] LABCONTROL_OnLogoff registrada (Gatilho: Bloqueio/Fechar Tampa)." -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Erro no OnLogoff: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "     TODAS AS TAREFAS CONFIGURADAS      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan