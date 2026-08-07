# ============================================================
# LABCONTROL
# Browser Reset Task
# ============================================================

Set-StrictMode -Version Latest

# ------------------------------------------------------------
# Load Core modules
# ------------------------------------------------------------
. "$PSScriptRoot\..\Core\Config.ps1"
. "$PSScriptRoot\..\Core\Logging.ps1"
. "$PSScriptRoot\..\Core\Browser.ps1"
. "$PSScriptRoot\..\Core\Profile.ps1"

# ------------------------------------------------------------
# Initialize LABCONTROL
# ------------------------------------------------------------
Initialize-LabControl

# ------------------------------------------------------------
# Reset browser profiles
# ------------------------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " LABCONTROL BROWSER RESET" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Define os navegadores que o laboratório utiliza
$Browsers = @("Chrome", "Edge")

foreach ($Browser in $Browsers) {
    Write-Host "Verificando Browser: $Browser"
    
    try {
        if (Test-BrowserRunning -Browser $Browser) {
            Write-Log -Level "WARNING" -Message "$Browser reset blocked because the browser is running."
            Write-Host "[SKIP] $Browser está em execução e não pode ser resetado no momento." -ForegroundColor Yellow
            Write-Host ""
            continue # Pula para o próximo navegador da lista em vez de travar o script inteiro
        }

        Write-Host "Restaurando perfil..."
        $Result = Restore-Profile -Browser $Browser

        if (-not $Result) {
            throw "A restauração do perfil do $Browser falhou."
        }

        Write-Log -Level "INFO" -Message "$Browser profile reset successfully."
        Write-Host "[ OK ] Perfil do $Browser restaurado com sucesso." -ForegroundColor Green
        Write-Host ""
    }
    catch {
        Write-Log -Level "ERROR" -Message "Erro crítico no $($Browser): $($_.Exception.Message)"
        Write-Host "[FAIL] $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
    }
}