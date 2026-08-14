# ==============================================================================
# Script: WebFilter.ps1
# Description: Aplica a base global do bloqueio de sites (gerenciado pelo OnLogon).
# ==============================================================================
Write-Host "-> Preparando base do Filtro Web..."

$edgeGlobal = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist"
$chromeGlobal = "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist"

# Garante que a chave existe e injeta um site de teste, o OnLogon fara o resto.
if (-not (Test-Path $edgeGlobal)) { New-Item -Path $edgeGlobal -Force | Out-Null }
if (-not (Test-Path $chromeGlobal)) { New-Item -Path $chromeGlobal -Force | Out-Null }
Set-ItemProperty -Path $edgeGlobal -Name "1" -Value "poki.com" -Type String
Set-ItemProperty -Path $chromeGlobal -Name "1" -Value "poki.com" -Type String

Write-Host "[ OK ] Base do filtro criada." -ForegroundColor Green