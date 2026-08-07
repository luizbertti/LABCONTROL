# ==============================================================================
# Script: ClearDownloads.ps1
# Description: Limpa todo o conteúdo da pasta Downloads do usuário atual.
# ==============================================================================

# Importação dos módulos Core (retornando um nível na estrutura de pastas)
. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando rotina de limpeza: Downloads." -Level "INFO"

# Define o caminho da pasta Downloads do usuário que está executando o script
$downloadsPath = Join-Path -Path $env:USERPROFILE -ChildPath "Downloads"

Write-Host "Verificando a pasta: $downloadsPath"

if (Test-Path -Path $downloadsPath) {
    try {
        # Lista todo o conteúdo e força a exclusão (-Force lida com arquivos ocultos/somente leitura)
        Get-ChildItem -Path $downloadsPath -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction Stop
        
        Write-Log -Message "Conteúdo da pasta Downloads excluído com sucesso." -Level "INFO"
        Write-Host "[ OK ] Pasta Downloads limpa." -ForegroundColor Green
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Log -Message "Falha ao limpar a pasta Downloads: $errorMessage" -Level "ERROR"
        Write-Host "[FAIL] Erro ao limpar Downloads. Verifique os logs." -ForegroundColor Red
    }
}
else {
    Write-Log -Message "Caminho não encontrado: $downloadsPath" -Level "WARNING"
    Write-Host "[SKIP] Pasta Downloads não encontrada." -ForegroundColor Yellow
}