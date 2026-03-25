# Claude Framework Installer (Windows)
# Usage: irm https://raw.githubusercontent.com/VDRTech1/claude-framework/main/install.ps1 | iex
# Or:    git clone https://github.com/VDRTech1/claude-framework.git; cd claude-framework; .\install.ps1

$ErrorActionPreference = "Stop"

$RepoUrl = "https://raw.githubusercontent.com/VDRTech1/claude-framework/main"
$ProjectDir = if ($args[0]) { $args[0] } else { "." }

Write-Host "=== Claude Framework Installer ===" -ForegroundColor Cyan
Write-Host "Target: $ProjectDir"
Write-Host ""

# Detect if running from cloned repo or remote
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Local = Test-Path (Join-Path $ScriptDir "RULES.md")

if ($Local) {
    Write-Host "Installing from local clone: $ScriptDir"
} else {
    Write-Host "Installing from GitHub..."
}

function Copy-FrameworkFile {
    param([string]$Src, [string]$Dest)
    if ($Local) {
        Copy-Item (Join-Path $ScriptDir $Src) -Destination $Dest -Force
    } else {
        Invoke-WebRequest -Uri "$RepoUrl/$Src" -OutFile $Dest -UseBasicParsing
    }
}

# --- Project files ---

# RULES.md — always overwrite (framework-managed)
Copy-FrameworkFile "RULES.md" (Join-Path $ProjectDir "RULES.md")
Write-Host "  RULES.md installed"

# CLAUDE.md — only if not exists (project-specific, don't overwrite)
$ClaudeMd = Join-Path $ProjectDir "CLAUDE.md"
if (-not (Test-Path $ClaudeMd)) {
    Copy-FrameworkFile "CLAUDE.md.template" $ClaudeMd
    Write-Host "  CLAUDE.md created from template"
} else {
    Write-Host "  CLAUDE.md already exists - skipped"
}

# CHANGELOG.md — only if not exists
$ChangelogMd = Join-Path $ProjectDir "CHANGELOG.md"
if (-not (Test-Path $ChangelogMd)) {
    "# CHANGELOG" | Out-File -FilePath $ChangelogMd -Encoding utf8
    Write-Host "  CHANGELOG.md created"
} else {
    Write-Host "  CHANGELOG.md already exists - skipped"
}

# --- Directories ---
New-Item -ItemType Directory -Path (Join-Path $ProjectDir "docs\checkpoints") -Force | Out-Null
Write-Host "  docs\checkpoints\ created"

New-Item -ItemType Directory -Path (Join-Path $ProjectDir "scripts") -Force | Out-Null
Write-Host "  scripts\ created"

# --- Skills (global ~/.claude/commands/) ---
$CommandsDir = Join-Path $env:USERPROFILE ".claude\commands"
New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null

foreach ($skill in @("handover", "resume", "preprod", "review", "debug", "codex", "ashy-init", "inov")) {
    Copy-FrameworkFile "skills/$skill.md" (Join-Path $CommandsDir "$skill.md")
    Write-Host "  /$skill skill installed"
}

# --- Status bar ---
$HooksDir = Join-Path $env:USERPROFILE ".claude\hooks"
New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null

Copy-FrameworkFile "statusbar/status.sh" (Join-Path $HooksDir "status.sh")
Write-Host "  status bar installed"

# --- Register status bar in settings.json ---
$SettingsFile = Join-Path $env:USERPROFILE ".claude\settings.json"

if (-not (Test-Path $SettingsFile)) {
    "{}" | Out-File -FilePath $SettingsFile -Encoding utf8
}

$SettingsContent = Get-Content $SettingsFile -Raw
if ($SettingsContent -notmatch "status.sh") {
    try {
        $Settings = $SettingsContent | ConvertFrom-Json
    } catch {
        $Settings = @{}
    }
    $Settings | Add-Member -NotePropertyName "statusLine" -NotePropertyValue @{
        type    = "command"
        command = "bash `$HOME/.claude/hooks/status.sh"
    } -Force
    $Settings | ConvertTo-Json -Depth 10 | Out-File -FilePath $SettingsFile -Encoding utf8
    Write-Host "  status bar registered in settings.json"
} else {
    Write-Host "  status bar already registered in settings.json - skipped"
}

Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Green
Write-Host ""
Write-Host "Skills installed (~/.claude/commands/):"
Write-Host "  /handover  - Session handover with checkpoint, versioning, db export"
Write-Host "  /resume    - Resume from latest checkpoint"
Write-Host "  /preprod   - Pre-production readiness (SDLC + OWASP Top 10)"
Write-Host "  /review    - Structured code review (correctness, security, quality)"
Write-Host "  /debug     - Structured debugging workflow (5 Whys)"
Write-Host "  /codex     - Joint review with OpenAI Codex CLI (two-model analysis)"
Write-Host "  /ashy-init - Interactive project setup wizard (run first after install)"
Write-Host "  /inov      - Radical innovation proposals"
Write-Host ""
Write-Host "Status bar: git branch/status | rotating quote"
Write-Host ""
Write-Host "Project files:"
Write-Host "  RULES.md      - Development rules (updated)"
Write-Host "  CLAUDE.md     - Project context (edit for your project)"
Write-Host "  CHANGELOG.md  - Version history"
Write-Host "  docs\checkpoints\ - Session checkpoints"
Write-Host "  scripts\      - Utility scripts"
