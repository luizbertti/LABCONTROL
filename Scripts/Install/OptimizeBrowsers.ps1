# ==============================================================================
# Script: OptimizeBrowsers.ps1
# Description: Aplica politicas no Windows para impedir Edge/Chrome em segundo plano.
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       OTIMIZANDO NAVEGADORES DO LAB    " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$edgePolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
$chromePolicy = "HKLM:\SOFTWARE\Policies\Google\Chrome"

Write-Host "-> Aplicando restricoes no Registro do Windows..."

try {
    # Cria as pastas de politica caso nao existam no Windows
    if (-not (Test-Path $edgePolicy)) { New-Item -Path $edgePolicy -Force | Out-Null }
    if (-not (Test-Path $chromePolicy)) { New-Item -Path $chromePolicy -Force | Out-Null }

    # Desativa Startup Boost e Background Apps no Edge
    Set-ItemProperty -Path $edgePolicy -Name "StartupBoostEnabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $edgePolicy -Name "BackgroundModeEnabled" -Value 0 -Type DWord
    Write-Host "  [ OK ] Edge bloqueado de rodar em segundo plano." -ForegroundColor Green

    # Desativa Background Apps no Chrome (por garantia)
    Set-ItemProperty -Path $chromePolicy -Name "BackgroundModeEnabled" -Value 0 -Type DWord
    Write-Host "  [ OK ] Chrome bloqueado de rodar em segundo plano." -ForegroundColor Green
    
} catch {
    Write-Host "  [FAIL] Erro ao aplicar politicas: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "    OTIMIZACAO CONCLUIDA COM SUCESSO    " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan