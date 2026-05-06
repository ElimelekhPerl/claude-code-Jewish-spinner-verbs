# install.ps1 — Install Jewish spinner verbs into Claude Code.
# Windows PowerShell 5.1+. No external dependencies required.

$ErrorActionPreference = 'Stop'

$RepoRaw      = "https://raw.githubusercontent.com/ElimelekhPerl/claude-code-Jewish-spinner-verbs/refs/heads/main/packages"
$SettingsDir  = Join-Path $env:USERPROFILE ".claude"
$SettingsFile = Join-Path $SettingsDir "settings.json"

function Say  { param($msg) Write-Host "==> $msg" -ForegroundColor Green }
function Warn { param($msg) Write-Host "==> $msg" -ForegroundColor Yellow }
function Err  { param($msg) Write-Host "==> $msg" -ForegroundColor Red }

function Fetch-Verbs {
  param($Pkg)
  $tmp = [System.IO.Path]::GetTempFileName()
  try {
    Invoke-WebRequest -Uri "$RepoRaw/$Pkg.json" -OutFile $tmp -UseBasicParsing
    $data = Get-Content $tmp -Raw | ConvertFrom-Json
    Remove-Item $tmp -Force
    return $data
  } catch {
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    throw "Couldn't fetch $Pkg.json. Check your internet connection."
  }
}

# --- choose package ---
Write-Host ""
Write-Host "Which verbs do you want to install?"
Write-Host "  [y] Yeshivish  — beis medrash slang (Davening, Twirling tzitzis...)"
Write-Host "  [i] Israeli    — Israeli slang in English (Yalla-ing, Eating shawarma...)"
Write-Host "  [b] Both"
Write-Host ""
$PkgChoice = Read-Host "Package [y/i/b]"
$Packages = switch ($PkgChoice.ToLower()) {
  'y' { @('yeshivish') }
  'i' { @('israeli') }
  'b' { @('yeshivish', 'israeli') }
  default { Err "Invalid choice. Run the script again."; exit 1 }
}

# --- choose mode ---
Write-Host ""
Write-Host "How should these verbs interact with the built-in Claude Code spinner?"
Write-Host "  [a] Append   — add your verbs alongside the existing built-in list"
Write-Host "  [r] Replace  — use only your verbs, drop all defaults"
Write-Host ""
$ModeChoice = Read-Host "Mode [a/r]"
$Mode = switch ($ModeChoice.ToLower()) {
  'a' { 'append' }
  'r' { 'replace' }
  default { Err "Invalid choice. Run the script again."; exit 1 }
}

# --- fetch selected packages ---
Say "Fetching verb package(s): $($Packages -join ', ')..."
$CombinedVerbs = @()
foreach ($Pkg in $Packages) {
  try {
    $verbs = Fetch-Verbs $Pkg
    $CombinedVerbs += $verbs
  } catch {
    Err $_; exit 1
  }
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
  Write-Host "  [o] Overwrite — replace the whole file (loses other settings)"
  Write-Host "  [c] Cancel"
  Write-Host ""
  $ExistingChoice = Read-Host "Choose [m/o/c]"
  $Action = switch ($ExistingChoice.ToLower()) {
    'm' { 'merge' }
    'o' { 'overwrite' }
    default { Say "Nothing done. Tzu gezunt."; exit 0 }
  }
}

# --- backup ---
if (Test-Path $SettingsFile) {
  $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $Backup = "$SettingsFile.bak.$Timestamp"
  Copy-Item $SettingsFile $Backup
  Say "Backed up existing settings to: $Backup"
}

# --- build config object ---
$SpinnerConfig = [PSCustomObject]@{
  spinnerVerbs = [PSCustomObject]@{
    mode  = $Mode
    verbs = $CombinedVerbs
  }
}

# --- write ---
switch ($Action) {
  { $_ -in 'install','overwrite' } {
    $SpinnerConfig | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
  }
  'merge' {
    $existing = Get-Content $SettingsFile -Raw | ConvertFrom-Json
    $existing | Add-Member -Force -NotePropertyName 'spinnerVerbs' -NotePropertyValue $SpinnerConfig.spinnerVerbs
    $existing | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
  }
}

Say "Done. Installed $($CombinedVerbs.Count) verbs (mode: $Mode)."
Say "Restart Claude Code to see the new spinner."
Say "If you change your mind, your old settings are in the .bak file."
