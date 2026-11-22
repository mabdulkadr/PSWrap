@ECHO OFF
TITLE PSWrap
ECHO Starting PSWrap...
POWERSHELL.EXE -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0PSWrap.ps1"
IF ERRORLEVEL 1 ECHO The script exited with an error.
PAUSE
