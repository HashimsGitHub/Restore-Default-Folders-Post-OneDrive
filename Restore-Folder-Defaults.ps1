# --- Elevate Script if Not Running as Admin ---
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script as administrator
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# --- Stop explorer.exe ---
Stop-Process -Name explorer -Force

Start-Sleep -Seconds 2

# --- Folder Definitions ---
$folders = @{
    "Desktop"       = "Desktop"
    "Personal"      = "Documents"
    "Downloads"     = "Downloads"
    "My Music"      = "Music"
    "My Pictures"   = "Pictures"
    "My Video"      = "Videos"
    "Favorites"     = "Favorites"
    "Contacts"      = "Contacts"
    "Links"         = "Links"
    "SavedGames"    = "Saved Games"
    "Searches"      = "Searches"
    "3D Objects"    = "3D Objects"
}

# --- Process Each Folder ---
foreach ($regName in $folders.Keys) {
    $relativePath = $folders[$regName]
    $fullPath = Join-Path $env:USERPROFILE $relativePath

    # Create folder if it doesn't exist
    if (-Not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath | Out-Null
    }

    # Update registry values for Shell Folders (REG_SZ)
    try {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" `
            -Name $regName -Value $fullPath -ErrorAction Stop
    } catch {
        Write-Warning "Could not write Shell Folders registry for $regName"
    }

    # Update registry values for User Shell Folders (REG_EXPAND_SZ)
    try {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" `
            -Name $regName -Value "%USERPROFILE%\$relativePath" -ErrorAction Stop
    } catch {
        Write-Warning "Could not write User Shell Folders registry for $regName"
    }

    # Set +r -s -h attributes (recursive)
    cmd /c "attrib +r -s -h `"$fullPath`" /S /D"
}

# --- Restart Explorer ---
Start-Sleep -Seconds 1
Start-Process explorer.exe
