*Leia isso em [Português](README.pt-br.md)*

# LABCONTROL 🚀

**LABCONTROL** is an automated system developed in PowerShell, focused on managing and sanitizing computers in educational laboratories. 

Its main objective is to ensure that each student finds a completely clean, sterile, and standardized system and browsing environment (Chrome/Edge), regardless of what the previous user did.

## ⚙️ How it Works?

The system operates on three main fronts:
1. **Ephemeral Launchers:** Browsers do not run from their default profiles. The system creates temporary "clones" (`Runtime`) based on an untouchable mold (`Templates`).
2. **Automated Maintenance:** Deep cleaning of caches, temporary files, and the Downloads folder.
3. **Session Triggers (Tasks):** Cleaning routines are triggered silently by Windows at the following times:
   - Upon machine startup (`OnLogon`).
   - During the night (`DailyCleanup`).
   - When the notebook is locked or the lid is closed (`OnLogoff / Lock`).

## 📁 Directory Structure

- `Scripts/Core/`: Base modules (Logging, Configuration, Process Management).
- `Scripts/Launchers/`: Smart shortcuts that prepare and open the browsers.
- `Scripts/Maintenance/`: Cleaning engines (Downloads, Temp, Backup, and Template Update).
- `Scripts/Tasks/`: Scheduled triggers in Windows that call the maintenance scripts.
- `Scripts/Install/`: Automated installer for new machines.

*Note: Runtime data, templates, and logs are stored in a local folder (`C:\LABCONTROL_DATA`), which is ignored by Git to protect sensitive information.*

## 🛠️ Installation (New Machine)

To deploy LABCONTROL on a new lab computer:
1. Clone this repository on the machine.
2. Open **PowerShell as Administrator**.
3. Run the master installation script:
   ```powershell
   .\Scripts\Install\InstallLab.ps1