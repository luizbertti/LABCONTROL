Write-Host "Iniciando domesticação do Windows Update..." -ForegroundColor Cyan

# Caminhos do Registro para Políticas do Windows Update
$auKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$wuKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$doKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"

if (-not (Test-Path $auKey)) { New-Item -Path $auKey -Force | Out-Null }
if (-not (Test-Path $wuKey)) { New-Item -Path $wuKey -Force | Out-Null }
if (-not (Test-Path $doKey)) { New-Item -Path $doKey -Force | Out-Null }

try {
    # 1. Proíbe o reinício forçado se houver alguém usando o PC
    Set-ItemProperty -Path $auKey -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord
    
    # 2. Configura o "Horário Ativo" (Active Hours) para 07:00 às 18:00
    Set-ItemProperty -Path $wuKey -Name "SetActiveHours" -Value 1 -Type DWord
    Set-ItemProperty -Path $wuKey -Name "ActiveHoursStart" -Value 7 -Type DWord  # 07:00
    Set-ItemProperty -Path $wuKey -Name "ActiveHoursEnd" -Value 18 -Type DWord   # 18:00

    # 3. Impede que o PC reinicie do nada (desativa o auto-restart para updates)
    Set-ItemProperty -Path $auKey -Name "NoAutoUpdate" -Value 0 -Type DWord
    Set-ItemProperty -Path $auKey -Name "AUOptions" -Value 3 -Type DWord # 3 = Baixa automaticamente e notifica para instalar

    # 4. Desliga o P2P de atualizações (Delivery Optimization) para poupar internet
    Set-ItemProperty -Path $doKey -Name "DODownloadMode" -Value 0 -Type DWord

    Write-Host "[ OK ] Windows Update domado com sucesso!" -ForegroundColor Green
    Write-Host "O PC so vai baixar atualizacoes em segundo plano e aguardar o fim do dia para instalar." -ForegroundColor Yellow
}
catch {
    Write-Host "[ERRO] Falha ao configurar o Windows Update: $($_.Exception.Message)" -ForegroundColor Red
}