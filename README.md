*Leia isso em [Português](README.pt-br.md)*

# LABCONTROL 🚀

**LABCONTROL** is an automated system developed in PowerShell, focused on managing, securing, and sanitizing computers in educational laboratories. 

Its main objective is to ensure that each student finds a completely clean, sterile, and standardized system environment, while giving teachers and administrators full control over the machines.

## ⚙️ How it Works?

The system operates on four main fronts:
1. **Automated Maintenance & Sanitization:** Deep cleaning of caches, temporary files, the Downloads folder, and user personal folders to reset the workspace.
2. **Ephemeral Launchers:** Browsers (Chrome/Edge) do not run from their default profiles. The system creates temporary "clones" (`Runtime`) based on an untouchable mold (`Templates`).
3. **Security & Lockdown:** Restricts visual changes (locks the Desktop, Start Menu, and Lockscreen) and enforces a robust Web Filter for students, with an automatic bypass for the Admin account.
4. **Energy & System Management:** Automatically shuts down the lab machines at the end of the day and domesticates Windows Update policies to prevent unexpected reboots during classes.

## 🕒 Session Triggers (Tasks)
Cleaning and management routines are triggered silently by Windows at the following times:
   - Upon machine startup (`OnLogon`).
   - When the user logs out or the machine is locked (`OnLogoff / Lock`).
   - Automatically at the end of the lab's operating hours (`AutoShutdown`).

## 📁 Directory Structure

- `Scripts/Core/`: Base modules (Logging, Configuration, Process Management).
- `Scripts/Launchers/`: Smart shortcuts that prepare and open the browsers.
- `Scripts/Maintenance/`: Cleaning engines and system policy enforcers (Windows Update, Workspace reset).
- `Scripts/Tasks/`: Scheduled triggers in Windows that call the maintenance scripts and auto-shutdown.
- `Scripts/Install/`: Automated master installer for new machines.

*Note: Runtime data, templates, and logs are stored in a local folder (`C:\LABCONTROL_DATA` and `C:\LABCONTROL\Logs`), which is ignored by Git to protect sensitive information.*

## 🛠️ Installation (New Machine)

To deploy LABCONTROL on a new lab computer:
1. Clone this repository on the machine.
2. Open **PowerShell as Administrator**.
3. Run the master installation script:
   ```powershell
   .\Scripts\Install\InstallLab.ps1