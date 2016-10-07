:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Renames LabVIEW's default Volume to Adafruit_FX_Installer
:: and adds it to a zip file.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
cls

set BAT_PATH=%~dp0
set endpause=7
set retryNum=0
set retryMax=1

if not exist "!BAT_PATH!Volume" (
  echo No new build volume found.
  goto :end
)

echo Moving Volume Directory
rd /s /q "!BAT_PATH!Adafruit_FX_Installer"

:retry
ping 127.0.0.1 -n 2 >nul
if %retryNum% == %retryMax% goto :end
if %retryNum% neq 0 echo Retrying Move
set /a retryNum=%retryNum%+1
move /y "!BAT_PATH!Volume" "!BAT_PATH!Adafruit_FX_Installer"
if errorlevel 1 (
  echo.
  goto :retry
)

echo Making zip file.
"C:\Program Files\7-Zip\7z.exe" u -tzip "!BAT_PATH!Adafruit_FX_Installer.zip" "!BAT_PATH!Adafruit_FX_Installer"
echo.

echo Cleaning up
rd /s /q "!BAT_PATH!Adafruit_FX_Installer"

:end
echo|set /p="Closing in !endpause! seconds"
for /l %%i in (1,1,!endpause!) do (
echo|set /p="."
ping 127.0.0.1 -n 2 >nul
)