@echo off
REM WordPress Docker Installer for Windows
REM by Avodah Systems

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM Check if PowerShell execution policy allows scripts
powershell -Command "if ((Get-ExecutionPolicy) -gt 'RemoteSigned') { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser }"

REM Run the GUI installer
powershell -ExecutionPolicy Bypass -File "%~dp0GUI-Installer.ps1"
