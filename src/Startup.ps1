<#
.TITLE
    PSWrap Application Startup Logic

.SYNOPSIS
    STA check, settings restore, log init, theme apply, window launch.

.DESCRIPTION
    Handles STA apartment state enforcement, user settings restoration,
    log file initialization, theme application, window icon loading,
    keyboard shortcut registration, and window display.

.TAGS
    Startup,STA,Initialization,Window,Launch

.MINROLE
    Reader

.PERMISSIONS
    N/A — local process management only

.AUTHOR
    admin

.VERSION
    1.0.0

.CHANGELOG
    1.0.0 - Initial release

.LASTUPDATE
    2026-06-17

.EXAMPLE
    . .\src\Startup.ps1
    Initializes and launches the PSWrap GUI window.

.NOTES
    Runs after all modules are loaded and UI elements are resolved.
    F5 key refreshes UI state. Window is shown as a modal dialog.
#>

if ([System.Threading.Thread]::CurrentThread.GetApartmentState() -ne 'STA') {
    $processName = [System.IO.Path]::GetFileName((Get-Process -Id $pid).MainModule.FileName)
    if ($processName -ieq 'pwsh.exe') {
        Write-Warning 'PSWrap requires Windows PowerShell 5.1 with STA support. Run with powershell.exe -STA.'
    } else {
        Write-Warning 'This application requires STA apartment state. Restarting...'
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = (Get-Process -Id $pid).MainModule.FileName
        $psi.Arguments = "-STA -File `"$PSCommandPath`""
        $psi.UseShellExecute = $true
        try { $proc = [System.Diagnostics.Process]::Start($psi); if ($proc -and -not $proc.HasExited) { exit } }
        catch { Write-Warning "Auto-restart failed: $($_.Exception.Message). Continuing in current process." }
    }
}

# Restore User Settings
try {
    $script:AppSettings = @{ ToastEnabled = $true }
    $settings = Load-UserSettings
    if ($settings) {
        $script:AppSettings = $settings
        if ($settings.Theme) { $script:IsDarkMode = ($settings.Theme -eq 'Dark') }
        if ($null -ne $settings.ToastEnabled) {
            if ($script:chkToastEnabled) { $script:chkToastEnabled.IsChecked = $settings.ToastEnabled }
        }
        if ($settings.LastProjectFolder) { $script:txtProjectFolder.Text = $settings.LastProjectFolder }
        if ($settings.LastSourceScript) { $script:txtSrcScript.Text = $settings.LastSourceScript }
        if ($settings.LastOutputPath) { $script:txtOutPath.Text = $settings.LastOutputPath }
        if ($settings.LastIconPath -and (Test-Path $settings.LastIconPath)) { $script:txtIconPath.Text = $settings.LastIconPath }
        if ($settings.BuildSettings) {
            foreach ($key in $script:dlgState.Keys) {
                $val = $settings.BuildSettings.$key
                if ($null -ne $val) { $script:dlgState.$key = $val }
            }
            $s = $script:dlgState
            if ($script:txtOptVersion) { $script:txtOptVersion.Text = $s.Ver }
            if ($script:txtOptProduct) { $script:txtOptProduct.Text = $s.Prod }
            if ($script:txtOptDesc) { $script:txtOptDesc.Text = $s.Desc }
            if ($script:txtOptCopyright) { $script:txtOptCopyright.Text = $s.Copy }
            if ($script:txtOptCompany) { $script:txtOptCompany.Text = $s.Comp }
            if ($script:txtOptTrademark) { $script:txtOptTrademark.Text = $s.Trade }
            if ($script:chkOptNoConsole) { $script:chkOptNoConsole.IsChecked = $s.NoCon }
            if ($script:chkOptNoOutput) { $script:chkOptNoOutput.IsChecked = $s.SOut }
            if ($script:chkOptNoError) { $script:chkOptNoError.IsChecked = $s.SErr }
            if ($script:chkOptRequireAdmin) { $script:chkOptRequireAdmin.IsChecked = $s.Adm }
            if ($script:chkOptConfigFile) { $script:chkOptConfigFile.IsChecked = $s.Cfg }
            if ($script:chkOptSaveIcon) { $script:chkOptSaveIcon.IsChecked = $s.CopyIcon }
            if ($script:radOptSTA) { $script:radOptSTA.IsChecked = $s.STA; $script:radOptMTA.IsChecked = -not $s.STA }
            if ($script:cboOptPlatform) { $script:cboOptPlatform.SelectedIndex = $s.Plat }
        }
    }
} catch { }

Initialize-LogFile
if ($script:FooterVersion) { $script:FooterVersion.Text = "Version $script:AppVersion" }

$script:Window.Add_Loaded({
    Set-Theme -Window $script:Window -IsDark $script:IsDarkMode

    if ($script:NavBtnCertSign) {
        $script:NavBtnCertSign.Background = [System.Windows.Media.Brushes]::Transparent
        $script:NavBtnCertSign.Foreground = $script:Window.TryFindResource('TextSecondaryBrush')
        $script:NavBtnCertSign.FontWeight = [System.Windows.FontWeights]::SemiBold
    }

    if ($script:IsDarkMode) {
        $script:ThemeIcon.Data = [System.Windows.Media.Geometry]::Parse($MoonIconData)
        $script:ThemeIcon.Fill = New-Brush '#CBD5E1'
        $script:ThemeToggleBtn.ToolTip = 'Switch to Light theme'
    }

    $iconFile = Join-Path $script:RootDir 'images\app-icon.png'
    if (Test-Path $iconFile) {
        try {
            $img = [System.Drawing.Image]::FromFile($iconFile)
            $hIcon = $img.GetHicon()
            $iconSrc = [System.Windows.Interop.Imaging]::CreateBitmapSourceFromHIcon($hIcon, [System.Windows.Int32Rect]::Empty, [System.Windows.Media.Imaging.BitmapSizeOptions]::FromEmptyOptions())
            $script:Window.Icon = $iconSrc; $img.Dispose()
        } catch { Add-LogLine "Could not load application icon from file: $_" 'WARNING' }
    }
    Update-UIState
}) | Out-Null

$script:Window.Add_KeyDown({
    if ($_.Key -eq 'F5') { $_.Handled = $true; Update-UIState; Add-LogLine -Message 'Interface refreshed via F5' -Level 'INFO' }
}) | Out-Null

$null = $script:Window.ShowDialog()
