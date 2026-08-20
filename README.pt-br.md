### `README.pt-br.md` (Português)

```markdown
*Read this in [English](README.md)*

# LABCONTROL 🚀

O **LABCONTROL** é um sistema automatizado, desenvolvido em PowerShell, focado no gerenciamento, segurança e higienização de computadores em laboratórios educacionais. 

Seu principal objetivo é garantir que cada aluno encontre um ambiente de sistema e navegação (Chrome/Edge) completamente limpo, estéril e padronizado, ao mesmo tempo que garante controle total para professores e administradores.

## ⚙️ Como Funciona?

O sistema atua em quatro frentes principais:
1. **Manutenção Automática & Higienização:** Limpeza profunda de caches, arquivos temporários, pasta de Downloads e pastas pessoais do usuário para resetar o ambiente.
2. **Launchers Efêmeros:** Os navegadores não rodam a partir de seus perfis padrão. O sistema cria "clones" temporários (`Runtime`) baseados em um molde intocável (`Templates`).
3. **Segurança e Bloqueios:** Restringe alterações visuais (trava a Área de Trabalho, Menu Iniciar e Tela de Bloqueio) e aplica um Filtro Web robusto exclusivo para os alunos, com liberação automática para a conta Administrador.
4. **Energia e Sistema:** Desliga os computadores automaticamente no fim do expediente e domestica as políticas do Windows Update para evitar reinicializações inesperadas durante as aulas.

## 🕒 Gatilhos de Sessão (Tasks)
As rotinas de limpeza e gerenciamento são acionadas silenciosamente pelo Windows nos seguintes momentos:
   - Ao iniciar a máquina (`OnLogon`).
   - Ao encerrar a sessão do usuário ou bloquear a máquina (`OnLogoff / Lock`).
   - Automaticamente no fim do horário de funcionamento do laboratório (`AutoShutdown`).

## 📁 Estrutura de Diretórios

- `Scripts/Core/`: Módulos base (Logging, Configurações, Manipulação de Processos).
- `Scripts/Launchers/`: Atalhos inteligentes que preparam e abrem os navegadores.
- `Scripts/Maintenance/`: Motores de limpeza e aplicadores de políticas (Windows Update, Reset de Workspace).
- `Scripts/Tasks/`: Gatilhos agendados no Windows que chamam as rotinas de manutenção e desligamento.
- `Scripts/Install/`: Instalador mestre automatizado para novas máquinas.

*Nota: Os dados em execução, templates e logs são armazenados em pastas locais (`C:\LABCONTROL_DATA` e `C:\LABCONTROL\Logs`), que são ignoradas pelo Git para proteger informações sensíveis.*

## 🛠️ Instalação (Nova Máquina)

Para implementar o LABCONTROL em um novo computador do laboratório:
1. Clone este repositório na máquina.
2. Abra o **PowerShell como Administrador**.
3. Execute o script mestre de instalação:
   ```powershell
   .\Scripts\Install\InstallLab.ps1