<#
.SYNOPSIS
    Downloads and runs AQ.exe as administrator
.DESCRIPTION
    This script downloads AQ.exe from GitHub and executes it with elevated privileges
.NOTES
    File Name      : Run-AQ.ps1
    Author         : Security Team
    Prerequisite   : PowerShell 5.1 or later
#>

# Bypass execution policy for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Download parameters
$githubRepo = "https://github.com/cctv-security/AQ/raw/main/AQ.exe"
$downloadPath = "$env:TEMP\AQ.exe"

function Download-And-Run {
    try {
        # Download the file
        Write-Host "Downloading AQ.exe from GitHub..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $githubRepo -OutFile $downloadPath -UseBasicParsing
        
        # Verify download
        if (Test-Path $downloadPath) {
            Write-Host "Download successful. File saved to: $downloadPath" -ForegroundColor Green
            
            # Check if we're running as administrator
            $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            
            if (-not $isAdmin) {
                # Relaunch as administrator
                Write-Host "Restarting script with elevated privileges..." -ForegroundColor Yellow
                Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { & '$downloadPath' }`""
            }
            else {
                # Already running as admin, just execute
                Write-Host "Running AQ.exe with administrator privileges..." -ForegroundColor Green
                Start-Process -FilePath $downloadPath -Verb RunAs
            }
        }
        else {
            Write-Host "Download failed. File not found at $downloadPath" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Error occurred: $_" -ForegroundColor Red
    }
}

# Main execution
Download-And-Run

# Optional: Clean up after execution
# Remove-Item -Path $downloadPath -Force
