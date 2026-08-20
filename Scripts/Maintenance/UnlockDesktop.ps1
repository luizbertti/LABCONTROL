# ==============================================================================
# Script: UnlockDesktop.ps1
# Description: Descongela a Area de Trabalho do aluno para o Professor editar
# ==============================================================================

# ⚠️ COLOQUE O NOME DO USUARIO DO ALUNO AQUI:
$NomeDoAluno = "Aluno"

$desktopPath = "C:\Users\$NomeDoAluno\Desktop"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     DESCONGELANDO AREA DE TRABALHO     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

try {
    $acl = Get-Acl -Path $desktopPath
    
    # Mesma alteração aqui para o destrancamento encontrar a regra certa
    $denyWriteRule = New-Object System.Security.AccessControl.FileSystemAccessRule($NomeDoAluno, "Write", "ContainerInherit, ObjectInherit", "None", "Deny")
    $denyDeleteRule = New-Object System.Security.AccessControl.FileSystemAccessRule($NomeDoAluno, "Delete, DeleteSubdirectoriesAndFiles", "ContainerInherit, ObjectInherit", "None", "Deny")
    
    $acl.RemoveAccessRule($denyWriteRule) | Out-Null
    $acl.RemoveAccessRule($denyDeleteRule) | Out-Null
    
    Set-Acl -Path $desktopPath -AclObject $acl
    
    Write-Host "`n[ OK ] Area de Trabalho DESTRANCADA com sucesso!" -ForegroundColor Green
}
catch {
    Write-Host "`n[ERRO] Falha ao destrancar a Area de Trabalho: $($_.Exception.Message)" -ForegroundColor Red
}