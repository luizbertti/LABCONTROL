# ==============================================================================
# Script: OnLogoff.ps1
# Description: Tarefa executada ao fazer logoff do Windows para limpeza profunda.
# ==============================================================================

# ==============================================================================
# INICIALIZAÇÃO DE SEGURANÇA (Pára-quedas)
# Garante que as variáveis globais existam mesmo se rodado manualmente
# ==============================================================================
if (-not (Get-Variable -Name "LabControl" -Scope Global -ErrorAction SilentlyContinue)) {
    $Global:LabControl = @{}
}
if (-not $Global:LabControl.Config) {
    $Global:LabControl.Config = @{
        Logging = @{
            Enabled = $true
            File = "C:\LABCONTROL\Logs\LabControl.log"
        }
    }
}
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando tarefa agendada: OnLogoff (Encerramento de Sessão)." -Level "INFO"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        INICIANDO LIMPEZA DE LOGOFF     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Reset dos Navegadores
$resetBrowserScript = "$PSScriptRoot\ResetBrowser.ps1"

if (Test-Path -Path $resetBrowserScript) {
    Write-Host "`n-> Resetando Navegadores..." -ForegroundColor Cyan
    try {
        & $resetBrowserScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetBrowser no Logoff: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao resetar navegadores." -ForegroundColor Red
    }
}

# 2. Limpeza Geral (Downloads e Temp via ResetLab)
$resetLabScript = "$PSScriptRoot\..\Maintenance\ResetLab.ps1"

if (Test-Path -Path $resetLabScript) {
    Write-Host "`n-> Limpando Arquivos Locais (Downloads/Temp)..." -ForegroundColor Cyan
    try {
        & $resetLabScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetLab no Logoff: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao limpar arquivos locais." -ForegroundColor Red
    }
}

# 3. Limpeza do Workspace (Papel de Parede e Pastas)
$resetWorkspaceScript = "$PSScriptRoot\..\Maintenance\ResetWorkspace.ps1"

if (Test-Path -Path $resetWorkspaceScript) {
    Write-Host "`n-> Limpando Workspace (Pastas e Papel de Parede)..." -ForegroundColor Cyan
    try {
        & $resetWorkspaceScript
    }
    catch {
        Write-Log -Message "Erro ao executar ResetWorkspace no Logoff: $($_.Exception.Message)" -Level "ERROR"
        Write-Host "[FAIL] Falha ao limpar o Workspace." -ForegroundColor Red
    }
}

# ==============================================================================
# 4. Restauração do Filtro Web (Focado no Aluno)
# ==============================================================================
Write-Host "`n-> Verificando regras de bloqueio de internet..." -ForegroundColor Cyan

try {
    if ($env:USERNAME -eq "Administrador") {
        Write-Host "  [SKIP] Usuario Administrador detectado. Mantendo internet livre!" -ForegroundColor Yellow
        Write-Log -Message "Bloqueio web ignorado para o usuario Administrador." -Level "INFO"
    }
    else {
        $blockedSites = @(
            #Jogos
            "poki.com", "clickjogos.com.br", "friv.com", "crazygames.com", 
            "kizi.com", "ojogos.com.br", "now.gg", "epicgames.com", "ea.com",
            "warthunder.com", "jogos360.com.br", "1001jogos.com.br", "minijogos.com.br",
            "playstation.com", "xbox.com", "playhop.com", "steampowered.com",
            "steamcommunity.com", "blizzard.com", "riotgames.com", "gog.com",
            "ubisoft.com", "minecraft.net", "roblox.com", "fortnite.com",
            "itch.io", "slither.io", "kongregate.com", "armorgames.com",
            "jogosfas.com", "nintendo.com", "cloudgaming.my", "cloud.gg",
            "oneplay.in", "7a0.com.br", "thefenomeno.com", "82-0.com",
            "pokeonline.com.br", "pokerogue.net", "pokerogue.org", "playpokerogue.com",
            "myinstants.com", "instants.meme", "pixabay.com", "soundbuttonsworld.com",
            "voicechanger.easeus.com", "memesoundboard.fun", "usesounds.com",
            "mixkit.co", "film.imyfone.com", "portaldosmemes.com.br",
            "soundinstants.com", "instantsoundboard.com", "tynker.com",
            "fnaffree.io", "fnafgames.io", "babyyellow.io", "squidgameunleashed.com",
            "dinorunner.com", "polybuzz.ai", "flappybird.io", "flappy-bird.uk",
            "flappybird.org", "poly-bus.firstory.io", "fab.com", "friv-2026.com",
            "frivclassic.com", "friv.vip", "frivjogosonline.com.br", "frive.net",
            "friv2016.info", "frivmax.com", "friv20.org", "jogosfrivoriginal.com",
            "friv1000000000.net", "neal.fun", "pranx.com", "pranxworld.com",
            "hackertyper.net", "shazam.com", "pokijogos.net", "coolmathgames.com",
            "fireboy-andwatergirl.io", "fireboynwatergirl.com", "girlgogames.com",
            "johnpork.ai", "kbhgames.com", "kbh.games", "gamebanana.com",
            "fnfmod.com", "newgrounds.com", "snokido.com", "thekbhgames.com",
            "gamejolt.com", "fnf-games.io", "fridaynightfunkin2.io", "fnfgo.com",
            "gamaverse.com", "play-games.com", "blocky.games", 
            "https://sites.google.com/site/unblockedgames77/",
            "https://sites.google.com/view/drive-u-7-home/home",
            "thestudentroom.co.uk",
            
            #Redes Sociais
            "discord.com", "instagram.com", "tiktok.com",
            "twitter.com", "x.com", "twitch.tv", "web.whatsapp.com",

            #Proxys
            "croxyproxy.com", "blockaway.net", "proxysite.com", "hide.me"
        )

        $edgeUser = "HKCU:\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist"
        $chromeUser = "HKCU:\SOFTWARE\Policies\Google\Chrome\URLBlocklist"

        if (-not (Test-Path $edgeUser)) { New-Item -Path $edgeUser -Force | Out-Null }
        if (-not (Test-Path $chromeUser)) { New-Item -Path $chromeUser -Force | Out-Null }

        $index = 1
        foreach ($site in $blockedSites) {
            Set-ItemProperty -Path $edgeUser -Name $index.ToString() -Value $site -Type String
            Set-ItemProperty -Path $chromeUser -Name $index.ToString() -Value $site -Type String
            $index++
        }

        Write-Log -Message "Filtro Web focado no usuario $($env:USERNAME) aplicado com sucesso." -Level "INFO"
        Write-Host "  [ OK ] Filtro Web trancado para o usuario $($env:USERNAME)." -ForegroundColor Green
    }
}
catch {
    Write-Log -Message "Erro ao restaurar Filtro Web no Logoff: $($_.Exception.Message)" -Level "ERROR"
    Write-Host "  [FAIL] Falha ao trancar o Filtro Web." -ForegroundColor Red
}
# ==============================================================================

Write-Log -Message "Tarefa OnLogoff finalizada com sucesso." -Level "INFO"
Write-Host "`n[ OK ] Tarefa OnLogoff concluída." -ForegroundColor Green