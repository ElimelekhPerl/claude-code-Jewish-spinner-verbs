# install.ps1 — Install Yeshivish spinner verbs into Claude Code.
# Windows PowerShell 5.1+. No external dependencies required.

$ErrorActionPreference = 'Stop'

$RepoRawUrl   = "https://raw.githubusercontent.com/ElimelekhPerl/yeshivish-spinner/refs/heads/master/spinner-verbs.json"
$SettingsDir  = Join-Path $env:USERPROFILE ".claude"
$SettingsFile = Join-Path $SettingsDir "settings.json"

function Say  { param($msg) Write-Host "==> $msg" -ForegroundColor Green }
function Warn { param($msg) Write-Host "==> $msg" -ForegroundColor Yellow }
function Err  { param($msg) Write-Host "==> $msg" -ForegroundColor Red }

# --- fetch verbs ---
Say "Fetching the latest verbs from GitHub..."
$TmpVerbs = [System.IO.Path]::GetTempFileName()

try {
  Invoke-WebRequest -Uri $RepoRawUrl -OutFile $TmpVerbs -UseBasicParsing
} catch {
  Err "Couldn't fetch the verbs file. Check your internet, or the URL:"
  Err "  $RepoRawUrl"
  exit 1
}

try {
  $null = Get-Content $TmpVerbs -Raw | ConvertFrom-Json
} catch {
  Err "Downloaded file isn't valid JSON. Aborting."
  Remove-Item $TmpVerbs -Force
  exit 1
}

# --- ensure settings dir exists ---
if (-not (Test-Path $SettingsDir)) {
  New-Item -ItemType Directory -Path $SettingsDir | Out-Null
}

# --- decide what to do with existing settings ---
$Action = "install"
if (Test-Path $SettingsFile) {
  Warn "Found existing settings at: $SettingsFile"
  Write-Host ""
  Write-Host "  [m] Merge     — keep your other settings, replace only spinnerVerbs"
  Write-Host "  [o] Overwrite — replace the whole file with just the spinner verbs"
  Write-Host "  [c] Cancel"
  Write-Host ""
  $Choice = Read-Host "Choose [m/o/c]"
  switch ($Choice.ToLower()) {
    'm' { $Action = "merge" }
    'o' { $Action = "overwrite" }
    default { Say "Nothing done. Tzu gezunt."; Remove-Item $TmpVerbs -Force; exit 0 }
  }
}

# --- backup ---
if (Test-Path $SettingsFile) {
  $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $Backup = "$SettingsFile.bak.$Timestamp"
  Copy-Item $SettingsFile $Backup
  Say "Backed up existing settings to: $Backup"
}

# --- write ---
switch ($Action) {
  { $_ -in 'install','overwrite' } {
    Copy-Item $TmpVerbs $SettingsFile -Force
  }
  'merge' {
    $existing = Get-Content $SettingsFile -Raw | ConvertFrom-Json
    $incoming = Get-Content $TmpVerbs -Raw | ConvertFrom-Json
    # Merge: incoming spinnerVerbs wins
    $existing | Add-Member -Force -NotePropertyName 'spinnerVerbs' -NotePropertyValue $incoming.spinnerVerbs
    $existing | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
  }
}

Remove-Item $TmpVerbs -Force
Say "Done. Restart Claude Code to see the new spinner verbs."
Say "If you change your mind, your old settings are in the .bak file."
