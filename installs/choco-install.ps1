# Windows native app installer via Chocolatey
# Run in an elevated PowerShell session:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\choco-install.ps1

# Install Chocolatey if missing
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Native Windows apps
choco install -y `
    ghostty `
    git `
    windows-terminal `
    wsl2
