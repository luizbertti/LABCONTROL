# ==============================================================================
# Script: LockDesktop.ps1
# Description: Congela a Area de Trabalho do aluno (impede criar/deletar arquivos)
# ==============================================================================

# ⚠️ COLOQUE O NOME DO USUARIO DO ALUNO AQUI:
$NomeDoAluno = "Aluno"

$desktopPath = "C:\Users\$NomeDoAluno\Desktop"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       CONGELANDO AREA DE TRABALHO      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

try {
    $acl = Get-Acl -Path $desktopPath
    
    # Mudamos "Usuários" para a variável $NomeDoAluno. Problema de idioma resolvido!
    $denyWriteRule = New-Object System.Security.AccessControl.FileSystemAccessRule($NomeDoAluno, "Write", "ContainerInherit, ObjectInherit", "None", "Deny")
    $denyDeleteRule = New-Object System.Security.AccessControl.FileSystemAccessRule($NomeDoAluno, "Delete, DeleteSubdirectoriesAndFiles", "ContainerInherit, ObjectInherit", "None", "Deny")
    
    $acl.AddAccessRule($denyWriteRule)
    $acl.AddAccessRule($denyDeleteRule)
    
    Set-Acl -Path $desktopPath -AclObject $acl
    
    Write-Host "`n[ OK ] Area de Trabalho TRANCADA com sucesso para o usuario: $NomeDoAluno!" -ForegroundColor Green
}
catch {
    Write-Host "`n[ERRO] Falha ao trancar a Area de Trabalho: $($_.Exception.Message)" -ForegroundColor Red
}