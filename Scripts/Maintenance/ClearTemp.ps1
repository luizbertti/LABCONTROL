# ==============================================================================
# Script: ClearTemp.ps1
# Description: Limpa as pastas de arquivos temporários do Windows.
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando rotina de limpeza: Arquivos Temporários." -Level "INFO"

# Utilizando .NET para pegar o caminho temporário 
$usuarioTemp = [System.IO.Path]::GetTempPath()
$sistemaTemp = "C:\Windows\Temp"

$tempPaths = @($usuarioTemp, $sistemaTemp)

foreach ($path in $tempPaths) {
    Write-Host "Analisando pasta: $path"
    
    if (Test-Path -Path $path) {
        try {
            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | `
                Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                
            Write-Log -Message "Limpeza executada no diretório: $path" -Level "INFO"
            Write-Host "[ OK ] Limpeza concluída em $path." -ForegroundColor Green
        }
        catch {
            # CORREÇÃO APLICADA AQUI: Isolando $path com $()
            Write-Log -Message "Erro ao acessar a pasta $($path): $($_.Exception.Message)" -Level "WARNING"
            Write-Host "[WARN] Problema ao processar $path." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "[SKIP] Pasta não encontrada: $path" -ForegroundColor Yellow
    }
}