# 📦 PSWrap — PowerShell Script to EXE Compiler

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)
![GUI](https://img.shields.io/badge/GUI-WPF-purple.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-FFDD00?style=for-the-badge)](https://www.buymeacoffee.com/mabdulkadrx)

---

## 📖 Overview

**PSWrap** is a modern **WPF-based GUI tool** that compiles **PowerShell scripts (.ps1)** into **native Windows executables (.exe)** using in-process C# CodeDOM compilation with `csc.exe` fallback.

---

## 🚀 Features

### Core Compilation Engine
- **In-process CodeDOM compilation** — falls back to `csc.exe` on PowerShell Core 7.x (uses .NET Framework SMA from GAC)
- **Script embedded as managed resource** — no Base64 strings or temp files
- **Async compilation** — non-blocking UI with background runspace and progress feedback
- **Assembly metadata** — version, description, product, copyright, company, trademark
- **Compilation options** — GUI/Console, suppress output/error, UAC manifest, config file, platform target, apartment state

### Companion File Bundling
- Embed entire project folders as embedded resources
- Bundled files grid with checkboxes for selective inclusion

### Custom Icon Support
- Embed `.ico` files directly
- Auto-convert from PNG/JPG/BMP/GIF to `.ico`
- Built-in default app icon when no custom icon provided

### Smart Detection
- Auto-detect `.ps1` and `.ico` files when project folder selected
- Source script, output path, and icon path auto-populate

### User Interface
- **Dark/Light theme** — Tailwind Slate design system with instant DynamicResource switching
- **Toast notifications** — non-blocking success/error/warning/info messages
- **KPI stat cards** — Last Compile, Source Size, Platform, Output Type, PS Version
- **Responsive layout** — Grid-based cards, fluid form inputs
- **Drag & drop** — drop `.ps1` files directly onto the window
- **Persistent settings** — theme, last paths, build config saved to `%APPDATA%\PSWrap\settings.json`

---

## 📋 Requirements

| Requirement | Details |
|-------------|---------|
| **OS** | Windows 7+ |
| **PowerShell** | 5.1 (legacy Windows PowerShell) or Core 7.x (csc.exe fallback) |
| **.NET Framework** | 4.7.2+ (included with Windows 10/11) |
| **Assemblies** | `System.Management.Automation`, `Windows Forms` |

---

## ▶️ Usage

```powershell
powershell.exe -STA -File "PSWrap.ps1"
```

Or double-click **PSWrap.ps1** in File Explorer.

### Steps

1. **Select Project Folder** (optional) — auto-detects `.ps1` and `.ico` files
2. **Select Source Script** — browse or drag-and-drop a `.ps1` file
3. **Set Output Path** — where the `.exe` will be saved
4. **Choose Custom Icon** (optional) — `.ico` file or image for auto-conversion
5. **Configure Settings** (optional) — metadata, compilation options
6. **Click "Compile to EXE"** — compilation runs in background

---

## 🏗️ Architecture

```
PSWrap/
├── PSWrap.ps1           — Main entry point
├── config/              — AppConstants, settings
├── src/                 — Core modules
│   ├── Environment.ps1
│   ├── Logging.ps1
│   ├── WpfHelpers.ps1
│   ├── Settings.ps1
│   ├── UiLoader.ps1
│   ├── EventHandlers.ps1
│   ├── Startup.ps1
│   └── Features/
│       ├── Compiler.ps1
│       ├── CertSign.ps1
│       ├── LogViewer.ps1
│       ├── AboutInfo.ps1
│       └── SettingsDialog.ps1
├── xaml/                — WPF layouts (MainWindow, LogViewer)
├── docs/                — Documentation
├── images/              — App icons
└── cert/                — Signing certificates
```

---

## 📁 Auto‑Created Logs

Log file stored automatically:

```
%APPDATA%\PSWrap\logs\PSWrap-YYYYMMDD.log
```

---

## 🧠 Auto‑Detection Behavior

When selecting **Project Folder**:
- Tool searches for `.ps1` files
- If found — auto-selects source script
- If multiple — selects first, logs count of detected files
- Same logic applies to `.ico` / image files for icon

---

## 🐛 Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| GUI doesn't appear | PowerShell not in STA mode | Run with `powershell.exe -STA -File "PSWrap.ps1"` |
| Compilation fails | .NET Framework not installed | Install .NET Framework 4.7.2+ |
| "csc.exe not found" | Roslyn not installed (PS 7.x fallback) | Install the Roslyn compiler or use PowerShell 5.1 |
| Icon not embedded | Invalid image format | Use .ico file or convert from PNG/JPG/BMP/GIF |
| Certificate signing fails | No admin rights or cert not trusted | Run as Administrator; check cert store |

---

## ☕ Support

If this project helps you, consider supporting it:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-FFDD00?style=for-the-badge)](https://www.buymeacoffee.com/mabdulkadrx)

---

## 📜 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## 👤 Author

**Mohammad Abdulkader Omar** 
Website: https://momar.tech 
LinkedIn: https://www.linkedin.com/in/mabdulkadr/ 
Version: **1.0.0** 

---

## ⚠ Disclaimer

These scripts are provided as-is. Test them in a staging environment before applying them to production. The author is not responsible for any unintended outcomes resulting from their use.
