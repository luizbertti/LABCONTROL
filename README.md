# LABCONTROL 🚀

O **LABCONTROL** é um sistema automatizado, desenvolvido em PowerShell, focado no gerenciamento e higienização de computadores em laboratórios educacionais. 

Seu principal objetivo é garantir que cada aluno encontre um ambiente de sistema e navegação (Chrome/Edge) completamente limpo, estéril e padronizado, independentemente do que o usuário anterior tenha feito.

## ⚙️ Como Funciona?

O sistema atua em três frentes principais:
1. **Launchers Efêmeros:** Os navegadores não rodam a partir de seus perfis padrão. O sistema cria "clones" temporários (`Runtime`) baseados em um molde intocável (`Templates`).
2. **Manutenção Automática:** Limpeza profunda de caches, arquivos temporários e pasta de Downloads.
3. **Gatilhos de Sessão (Tasks):** As rotinas de limpeza são acionadas silenciosamente pelo Windows nos seguintes momentos:
   - Ao iniciar a máquina (`OnLogon`).
   - Durante a madrugada (`DailyCleanup`).
   - Quando o notebook é bloqueado ou a tampa é fechada (`OnLogoff / Lock`).

## 📁 Estrutura de Diretórios

- `Scripts/Core/`: Módulos base (Logging, Configurações, Manipulação de Processos).
- `Scripts/Launchers/`: Atalhos inteligentes que preparam e abrem os navegadores.
- `Scripts/Maintenance/`: Motores de limpeza (Downloads, Temp, Backup e Update de Templates).
- `Scripts/Tasks/`: Gatilhos agendados no Windows que chamam as manutenções.
- `Scripts/Install/`: Instalador automatizado para novas máquinas.

*Nota: Os dados em execução, templates e logs são armazenados em uma pasta local (`C:\LABCONTROL_DATA`), que é ignorada pelo Git para proteger informações sensíveis.*

## 🛠️ Instalação (Nova Máquina)

Para implementar o LABCONTROL em um novo computador do laboratório:
1. Clone este repositório na máquina.
2. Abra o **PowerShell como Administrador**.
3. Execute o script mestre de instalação:
   ```powershell
   .\Scripts\Install\InstallLab.ps1