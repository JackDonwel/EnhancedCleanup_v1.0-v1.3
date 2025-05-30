# 🧹 Enhanced System Cleanup Script v1.3 – *Stealth Edition*

**Author:** Donwell  
**Version:** 1.3  
**Date:** 2025-05-30  
**License:** Public Domain  
**Target OS:** Windows 7–11 (Admin rights recommended)

---

## 🚀 Overview

This script is designed to clean up potentially malicious `.vbs` script droppers and shut down Windows-based scripting engines. It is tailored for **stealth environments**, with **minimal visibility**, **reduced AV detection**, and **optional remote status reporting** to a configured C2 endpoint.

---

## ✅ Features

- 🔒 **Stealthy deletion** of `.vbs` files in `C:\Windows\Temp`
- 🎯 **Silent termination** of `wscript.exe` and `cscript.exe` via `WMIC`
- 🛰️ Optional **remote status reporting** (C2)
- 🔕 Minimal console output (`LOG_VERBOSE=false` by default)
- 🧱 Compatible with `.bat` or compiled `.exe` versions

---

## ⚙️ Configuration

Edit the following variables at the top of the script as needed:

```bat
set "TARGET_TEMP_PATH=C:\Windows\Temp"
set "VBS_PATTERN=*.vbs"
set "LOG_VERBOSE=false"
set "C2_URL=http://your-cdn-like-server.com/report"
set "ENABLE_C2=true"
```

> **Note:** To prevent C2 mistakes, the script skips reporting if the `C2_URL` is empty or left default.

---

## 📦 Compilation (Optional)

To convert to `.exe` from **Kali Linux, Termux, or Windows**:

1. Download **[Bat_To_Exe_Converter](https://f2ko.de/en/b2e.php)**
2. Set:
   - Mode: **Invisible**
   - Output file: `cleanup.exe`
3. Click **Compile**

Or via CLI:

```bash
wine Bat_To_Exe_Converter_CLI.exe cleanup.bat cleanup.exe
```

---

## 🛠 Usage

**Run as Administrator**:

```bash
Right-click > Run as Administrator
```

OR in an elevated shell:

```cmd
cleanup.exe
```

---

## 🔍 Logging & Status

- Script status stored in:
  - `SCRIPT_STATUS` – OK, NOADMIN, or FAILURE
  - `ERRORS` – collected error flags (e.g. `VBS_DELETE_FAILED`, `TERM_wscript_FAILED`)
- If C2 reporting is enabled, it sends:
  ```
  http://your-c2-server.com/report?hostname=HOST&status=OK&t=EClean
  ```

---

## ⚠️ Warnings

- The script **terminates system processes** and **deletes files** silently.
- Ensure it's run in a **controlled or authorized environment** (e.g. bug bounty testing scope).
- Disable or modify the C2 callback logic before public or client-facing deployments.

---

## 📚 Changelog

**v1.3 – 2025-05-30**
- Switched to `wmic` for stealth process termination
- Replaced `del *.vbs` with `FOR` loop for better AV evasion
- Hardened PowerShell call for C2 with `-NoP -W Hidden`
- Reduced echo noise for stealth unless `LOG_VERBOSE=true`

---

## 🤝 Acknowledgements

Inspired by offensive security toolkits and red team needs. If you’re using this in a bug bounty context, hats off to you for helping secure the ecosystem.
