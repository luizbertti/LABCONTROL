# ==============================================================================
# Script: UpdateTemplates.ps1
# Description: Atualiza a pasta de templates com base no perfil atual em uso (Runtime).
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando rotina de atualizacao: Transformando Runtime em novo Template." -Level "INFO"

# Definição dos caminhos com base na sua estrutura local
$runtimePath = "C:\LABCONTROL_DATA\Runtime"
$templatePath = "C:\LABCONTROL_DATA\Templates"

$browsers = @("Chrome", "Edge")

foreach ($browser in $browsers) {
    $sourceDir = Join-Path -Path $runtimePath -ChildPath $browser
    $destDir = Join-Path -Path $templatePath -ChildPath $browser

    Write-Host "Atualizando template do navegador: $browser"

    if (Test-Path -Path $sourceDir) {
        try {
            # Garante que a pasta de destino exista
            if (!(Test-Path -Path $destDir)) {
                New-Item -ItemType Directory -Force -Path $destDir | Out-Null
            }

            # Limpa o template antigo antes de receber o novo para evitar resíduos de arquivos
            Remove-Item -Path "$destDir\*" -Recurse -Force -ErrorAction SilentlyContinue

            # Copia o conteúdo recém-configurado do Runtime para ser o novo Template
            Copy-Item -Path "$sourceDir\*" -Destination $destDir -Recurse -Force -ErrorAction Stop
            
            Write-Log -Message "Template do $($browser) atualizado com sucesso a partir do Runtime." -Level "INFO"
            Write-Host "[ OK ] Template do $browser atualizado." -ForegroundColor Green
        }
        catch {
            Write-Log -Message "Erro ao atualizar template do $($browser): $($_.Exception.Message)" -Level "ERROR"
            Write-Host "[FAIL] Falha ao atualizar template do $browser." -ForegroundColor Red
        }
    }
    else {
        Write-Log -Message "Diretório Runtime não encontrado para cópia: $sourceDir" -Level "WARNING"
        Write-Host "[SKIP] Runtime do $browser não encontrado em $sourceDir." -ForegroundColor Yellow
    }
}