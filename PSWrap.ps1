#Requires -Version 5.1
<#!
.SYNOPSIS
    PSWrap — PowerShell Script to EXE Compiler (GUI).

.DESCRIPTION
    A modern WPF-based GUI tool that compiles PowerShell scripts (.ps1) into
    native Windows executables (.exe) using in-process C# CodeDOM compilation
    with automatic csc.exe fallback on PowerShell Core 7.x.

    Features include dark/light theme, certificate signing, log viewer,
    companion file bundling, custom icon embedding, and async compilation.

    Requires: Windows PowerShell 5.1+, .NET Framework 4.7.2+, WPF
    Admin required for TrustRoot certificate option.

.EXAMPLE
    powershell.exe -STA -File "PSWrap.ps1"

.NOTES
    Author      : Mohammad Abdelkader Omar
    Website     : https://momar.tech
    LinkedIn    : https://www.linkedin.com/in/mabdulkadr/
    Date        : 2026-06-17
    Version     : 1.0.0
    Repo        : https://github.com/mabdulkadr/PSWrap
    Changelog   :
                 1.0.0 - Initial release.
#>

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$configDir  = Join-Path $scriptRoot 'config'
$srcDir     = Join-Path $scriptRoot 'src'
$script:EntryDir = $scriptRoot

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
if ($consolePtr -ne [IntPtr]::Zero) {
    [Console.Window]::ShowWindow($consolePtr, 0) | Out-Null
}

. (Join-Path $configDir 'AppConstants.ps1')
. (Join-Path $srcDir    'Environment.ps1')
. (Join-Path $srcDir    'Logging.ps1')
. (Join-Path $srcDir    'WpfHelpers.ps1')
. (Join-Path $srcDir    'Settings.ps1')
. (Join-Path $srcDir    'UiLoader.ps1')
. (Join-Path $script:FeaturesDir 'Compiler.ps1')
. (Join-Path $script:FeaturesDir 'CertSign.ps1')
. (Join-Path $script:FeaturesDir 'LogViewer.ps1')
. (Join-Path $script:FeaturesDir 'AboutInfo.ps1')
. (Join-Path $script:FeaturesDir 'SettingsDialog.ps1')
. (Join-Path $srcDir 'EventHandlers.ps1')
. (Join-Path $srcDir 'Startup.ps1')
