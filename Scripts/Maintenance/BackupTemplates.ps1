# ==============================================================================
# Script: BackupTemplates.ps1
# Description: Realiza o backup dos templates atuais dos navegadores.
# ==============================================================================

. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"

Write-Log -Message "Iniciando rotina de backup: Templates de Navegadores." -Level "INFO"

$sourcePath = "C:\LABCONTROL_DATA\Templates"
$backupPath = "C:\LABCONTROL_DATA\Backup"

$browsers = @("Chrome", "Edge")

foreach ($browser in $browsers) {
    $sourceDir = Join-Path -Path $sourcePath -ChildPath $browser
    $backupDir = Join-Path -Path $backupPath -ChildPath $browser

    Write-Host "Iniciando backup de: $browser"

    if (Test-Path -Path $sourceDir) {
        try {
            # Cria a pasta de backup se ela não existir
            if (!(Test-Path -Path $backupDir)) {
                New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
            }

            # Copia todo o conteúdo do Template para o Backup, substituindo arquivos antigos
            Copy-Item -Path "$sourceDir\*" -Destination $backupDir -Recurse -Force -ErrorAction Stop
            
            Write-Log -Message "Backup do $browser realizado com sucesso em $backupDir." -Level "INFO"
            Write-Host "[ OK ] Backup do $browser concluído." -ForegroundColor Green
        }
        catch {
            # CORREÇÃO APLICADA AQUI: Isolando $browser com $()
            Write-Log -Message "Erro ao realizar backup do $($browser): $($_.Exception.Message)" -Level "ERROR"
            Write-Host "[FAIL] Falha no backup do $browser." -ForegroundColor Red
        }
    }
    else {
        Write-Log -Message "Diretório de origem não encontrado: $sourceDir" -Level "WARNING"
        Write-Host "[SKIP] Template do $browser não encontrado em $sourceDir." -ForegroundColor Yellow
    }
}