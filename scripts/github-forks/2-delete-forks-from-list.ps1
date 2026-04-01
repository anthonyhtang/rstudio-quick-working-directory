# Deletes GitHub repos listed in forks-to-delete.txt (one full name per line: owner/repo).
# DESTRUCTIVE. Only runs deletes when you pass -ConfirmDeletion.
#
# Requires: gh auth login (same account that owns those forks)
#
# Usage:
#   1. Copy my-forks-list.txt to forks-to-delete.txt (or create it) and remove lines to keep.
#   2. Dry run (prints only):
#        .\2-delete-forks-from-list.ps1
#   3. Actually delete:
#        .\2-delete-forks-from-list.ps1 -ConfirmDeletion

param(
  [string] $ListPath = "",
  [switch] $ConfirmDeletion
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "Install GitHub CLI and run: gh auth login"
}

if (-not $ListPath) {
  $ListPath = Join-Path $PSScriptRoot "forks-to-delete.txt"
}

if (-not (Test-Path -LiteralPath $ListPath)) {
  Write-Error "List file not found: $ListPath`nCreate it from my-forks-list.txt after editing."
}

$lines = Get-Content -LiteralPath $ListPath -Encoding utf8
$repos = foreach ($line in $lines) {
  $t = $line.Trim()
  if ($t -eq "" -or $t.StartsWith("#")) { continue }
  if ($t -notmatch "^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$") {
    Write-Warning "Skipping invalid line: $line"
    continue
  }
  $t
}

$repos = $repos | Sort-Object -Unique

if ($repos.Count -eq 0) {
  Write-Host "No repositories to process (empty or only comments)."
  exit 0
}

Write-Host "Repositories in list ($($repos.Count)):"
$repos | ForEach-Object { Write-Host "  $_" }
Write-Host ""

if (-not $ConfirmDeletion) {
  Write-Host "Dry run only. To permanently delete these forks, run:"
  Write-Host "  .\2-delete-forks-from-list.ps1 -ConfirmDeletion"
  exit 0
}

foreach ($r in $repos) {
  Write-Host "Deleting $r ..."
  gh repo delete $r --yes
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "gh repo delete failed for: $r (exit $LASTEXITCODE)"
  }
}

Write-Host "Done."
