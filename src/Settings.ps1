<#
.TITLE
    PSWrap User Settings Persistence

.SYNOPSIS
    JSON-based save/load for user preferences (theme, paths, config).

.DESCRIPTION
    Provides JSON-based serialization and deserialization of user preferences
    including theme choice, last-used file paths, and build configuration.

.TAGS
    Settings,Persistence,JSON,Configuration

.MINROLE
    Reader

.PERMISSIONS
    N/A — writes to %APPDATA% only

.AUTHOR
    admin

.VERSION
    1.0.0

.CHANGELOG
    1.0.0 - Initial release

.LASTUPDATE
    2026-06-17

.EXAMPLE
    Save-UserSettings -Settings @{ Theme = 'Dark' }
    $settings = Load-UserSettings

.NOTES
    Settings file location: %APPDATA%\PSWrap\settings.json
    Saved automatically on application close and loaded on startup.
#>

# Serializes user preferences to JSON and writes to the settings file.
function Save-UserSettings {
    [CmdletBinding()]
    param([Parameter(Mandatory)][hashtable]$Settings)
    try {
        $dir = Split-Path $script:SettingsPath -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        $Settings | ConvertTo-Json -Compress | Set-Content -LiteralPath $script:SettingsPath -Encoding UTF8 -Force
    } catch { Add-LogLine -Message "Failed to save settings: $($_.Exception.Message)" -Level 'WARNING' }
}

# Deserializes and returns user preferences from the JSON settings file.
function Load-UserSettings {
    [CmdletBinding()]
    param()
    if (Test-Path $script:SettingsPath) {
        try {
            $content = Get-Content -LiteralPath $script:SettingsPath -Raw -Encoding UTF8
            if ($content) { return ($content | ConvertFrom-Json -ErrorAction Stop) }
        } catch { Add-LogLine -Message "Failed to load settings: $($_.Exception.Message)" -Level 'WARNING' }
    }
    return $null
}
