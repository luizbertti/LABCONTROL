# ==============================================================================
# Script: UpdateBookmarks.ps1
# Description: Atualiza o arquivo de favoritos dos templates dos navegadores.
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando rotina de atualização: Favoritos (Bookmarks)." -Level "INFO"

# Definição dos caminhos baseados na estrutura local (C:\LABCONTROL_DATA)
$masterBookmarks = "C:\LABCONTROL_DATA\Templates\Bookmarks"

$templates = @(
    @{ Name = "Chrome"; Path = "C:\LABCONTROL_DATA\Templates\Chrome\Default" },
    @{ Name = "Edge"; Path = "C:\LABCONTROL_DATA\Templates\Edge\Default" }
)

if (Test-Path -Path $masterBookmarks) {
    foreach ($browser in $templates) {
        Write-Host "Atualizando favoritos para: $($browser.Name)"
        
        # Garante que a pasta de destino exista no Template
        if (!(Test-Path -Path $browser.Path)) {
            New-Item -ItemType Directory -Force -Path $browser.Path | Out-Null
        }

        try {
            Copy-Item -Path $masterBookmarks -Destination "$($browser.Path)\Bookmarks" -Force -ErrorAction Stop
            Write-Log -Message "Favoritos do $($browser.Name) atualizados com sucesso." -Level "INFO"
            Write-Host "[ OK ] $($browser.Name) atualizado." -ForegroundColor Green
        }
        catch {
            Write-Log -Message "Erro ao copiar favoritos para $($browser.Name): $($_.Exception.Message)" -Level "ERROR"
            Write-Host "[FAIL] Falha ao atualizar $($browser.Name)." -ForegroundColor Red
        }
    }
}
else {
    Write-Log -Message "Arquivo mestre de favoritos não encontrado: $masterBookmarks" -Level "WARNING"
    Write-Host "[SKIP] Arquivo mestre não encontrado em $masterBookmarks. Nenhuma alteração feita." -ForegroundColor Yellow
}