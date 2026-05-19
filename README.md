<div align="center">

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Windows_logo_-_2012.svg/120px-Windows_logo_-_2012.svg.png" width="70" alt="Windows Logo"/>

# Restore Default Folders — Post OneDrive

**A PowerShell script that restores Windows default user folders to their correct locations after uninstalling OneDrive or switching accounts.**

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-GPL--3.0-green?style=for-the-badge)](LICENSE)
[![Latest Release](https://img.shields.io/badge/Release-Latest-brightgreen?style=for-the-badge)](https://github.com/HashimsGitHub/Restore-Default-Folders-Post-OneDrive/releases)

</div>

---

## The Problem

When you enable OneDrive folder backup (Known Folder Move), OneDrive silently redirects your Windows default folders — Desktop, Documents, Pictures, Videos, and others — away from their standard paths under `C:\Users\<YourName>\` and into the OneDrive sync directory. This is by design.

The problem is what happens when you **uninstall OneDrive** or **disconnect your account**: OneDrive does not restore those folder paths. Windows suddenly can't find your Desktop or Documents at the expected locations, applications break, and the OS starts behaving erratically — all because two registry keys are still pointing at a OneDrive path that no longer exists.

This script fixes that in seconds by recreating the correct folder paths and updating both registry keys (`Shell Folders` and `User Shell Folders`) back to their `%USERPROFILE%` defaults.

---

## What It Does

The script performs three actions for each affected folder:

1. **Creates the folder** at `%USERPROFILE%\<FolderName>` if it doesn't already exist
2. **Updates the registry** — writes the correct absolute path to `Shell Folders` and the portable `%USERPROFILE%\...` value to `User Shell Folders`
3. **Resets folder attributes** — clears any system/hidden flags that OneDrive may have set (`attrib +r -s -h`)

Explorer is stopped before the changes are applied and restarted cleanly afterward.

---

## Folders Restored

| Registry Key | Folder |
|---|---|
| `Desktop` | Desktop |
| `Personal` | Documents |
| `Downloads` | Downloads |
| `My Music` | Music |
| `My Pictures` | Pictures |
| `My Video` | Videos |
| `Favorites` | Favorites |
| `Contacts` | Contacts |
| `Links` | Links |
| `SavedGames` | Saved Games |
| `Searches` | Searches |
| `3D Objects` | 3D Objects |

---

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or later (included with Windows — no installation needed)
- Administrator privileges (the script auto-elevates itself if needed)

---

## Usage

### Option 1 — Download and run directly

1. Download [`Restore-Folder-Defaults.ps1`](https://github.com/HashimsGitHub/Restore-Default-Folders-Post-OneDrive/releases) from the latest release
2. Right-click the file → **Run with PowerShell**
3. If prompted by UAC, click **Yes** to allow administrator access
4. Wait a few seconds — Explorer will restart and your folders will be restored

### Option 2 — Run from PowerShell

Open PowerShell as Administrator and run:

```powershell
# If you haven't changed your execution policy, run this first (once):
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Then run the script:
.\Restore-Folder-Defaults.ps1
```

Or run it directly without changing your execution policy:

```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\Restore-Folder-Defaults.ps1"
```

> **Note:** The script automatically detects if it's not running as Administrator and re-launches itself with elevated privileges using `RunAs`. You don't need to manually open an admin prompt.

---

## How It Works

```
1. Check for admin rights → auto-elevate via RunAs if needed
2. Stop explorer.exe
3. For each folder:
   a. Create directory at %USERPROFILE%\<FolderName> if missing
   b. Write absolute path → HKCU\...\Shell Folders
   c. Write %USERPROFILE% path → HKCU\...\User Shell Folders
   d. Reset attributes (attrib +r -s -h /S /D)
4. Restart explorer.exe
```

---

## Important Notes

- **Back up your data first.** This script modifies registry values. While it only resets standard Windows paths, always ensure your personal files are backed up before running any system-level script.
- **Your files are not deleted.** The script only updates the registry pointers and creates missing folder paths. Any files still in the old OneDrive location remain there untouched — you may want to manually move them back to the restored folders afterward.
- **One-time fix.** This is not a background service. Run it once after uninstalling OneDrive or after a folder-redirection issue, and you're done.
- **Windows only.** This script uses Windows registry paths and is not applicable to macOS or Linux.

---

## Project Structure

```
Restore-Default-Folders-Post-OneDrive/
├── Restore-Folder-Defaults.ps1   # The PowerShell script
├── LICENSE                        # GPL-3.0 license
└── README.md
```

---

## Contributing

Issues and pull requests are welcome. If you encounter a folder that isn't covered, or a Windows version where the registry paths differ, please open an issue with details about your environment.

---

## License

Distributed under the [GNU General Public License v3.0](LICENSE).

---

<div align="center">

Built with ❤️ for everyone who just wanted to uninstall OneDrive in peace

**Hashim Hilal** — Cloud Architect

</div>
