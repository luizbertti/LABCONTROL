# ==============================================================================
# Script: WebFilter.ps1
# Description: Bloqueia o acesso a sites especificos (jogos, redes sociais, etc).
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      APLICANDO FILTRO DE INTERNET      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ==============================================================================
# ⚠️ LISTA NEGRA DE SITES (Adicione aqui os domínios que deseja bloquear)
# ==============================================================================
$blockedSites = @(
    "poki.com",
    "roblox.com",
    "clickjogos.com.br",
    "friv.com",
    "crazygames.com",
    "discord.com",
    "https://www.instagram.com/",
    "https://www.facebook.com/"
)

$edgeBlocklistPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist"
$chromeBlocklistPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist"

try {
    Write-Host "-> Configurando lista de bloqueio no Registro..."
    
    # Cria as pastas de bloqueio se não existirem
    if (-not (Test-Path $edgeBlocklistPath)) { New-Item -Path $edgeBlocklistPath -Force | Out-Null }
    if (-not (Test-Path $chromeBlocklistPath)) { New-Item -Path $chromeBlocklistPath -Force | Out-Null }

    # Limpa as listas antigas antes de aplicar a nova (para evitar lixo se você remover um site)
    Remove-ItemProperty -Path $edgeBlocklistPath -Name "*" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $chromeBlocklistPath -Name "*" -ErrorAction SilentlyContinue

    # Injeta a nova lista de bloqueios (O Windows exige que cada site tenha um número)
    $index = 1
    foreach ($site in $blockedSites) {
        Set-ItemProperty -Path $edgeBlocklistPath -Name $index.ToString() -Value $site -Type String
        Set-ItemProperty -Path $chromeBlocklistPath -Name $index.ToString() -Value $site -Type String
        $index++
    }

    Write-Host "[ OK ] Filtro web aplicado em ambos os navegadores. ($($blockedSites.Count) sites bloqueados)" -ForegroundColor Green
}
catch {
    Write-Host "[FAIL] Erro ao aplicar filtro: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "        FILTRO WEB CONFIGURADO          " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan