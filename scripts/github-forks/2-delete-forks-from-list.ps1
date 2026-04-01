# Deletes GitHub repos listed in forks-to-delete.txt (one full name per line: owner/repo).
# SAFETY: Skips any repo that is private, internal, or not a fork (even if wrongly listed).
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

function Test-PublicFork {
  param([string] $Repo)
  $raw = gh repo view $Repo --json isFork,isPrivate,visibility 2>$null
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($raw)) {
    return @{ Ok = $false; Reason = "could not read repo (missing or no access)" }
  }
  $m = $raw | ConvertFrom-Json
  if ($m.isFork -ne $true) {
    return @{ Ok = $false; Reason = "not a fork (your own repo or mis-tagged); will not delete" }
  }
  if ($m.isPrivate -eq $true) {
    return @{ Ok = $false; Reason = "private; will not delete" }
  }
  if ($m.visibility -in @("PRIVATE", "INTERNAL")) {
    return @{ Ok = $false; Reason = "visibility $($m.visibility); will not delete" }
  }
  return @{ Ok = $true; Reason = "" }
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

Write-Host "Repositories in file ($($repos.Count)) — checking each on GitHub..."
$toDelete = [System.Collections.Generic.List[string]]::new()
foreach ($r in $repos) {
  $check = Test-PublicFork -Repo $r
  if ($check.Ok) {
    Write-Host "  OK (public fork): $r"
    $toDelete.Add($r)
  } else {
    Write-Warning "SKIP $r — $($check.Reason)"
  }
}
Write-Host ""

if ($toDelete.Count -eq 0) {
  Write-Host "Nothing eligible to delete (all skipped or failed checks)."
  exit 0
}

Write-Host "Will delete $($toDelete.Count) public fork(s) (private / non-fork already excluded)."
$toDelete | ForEach-Object { Write-Host "  $_" }
Write-Host ""

if (-not $ConfirmDeletion) {
  Write-Host "Dry run only. To permanently delete the eligible forks above, run:"
  Write-Host "  .\2-delete-forks-from-list.ps1 -ConfirmDeletion"
  exit 0
}

foreach ($r in $toDelete) {
  $recheck = Test-PublicFork -Repo $r
  if (-not $recheck.Ok) {
    Write-Warning "Aborting delete for $r — $($recheck.Reason)"
    continue
  }
  Write-Host "Deleting $r ..."
  gh repo delete $r --yes
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "gh repo delete failed for: $r (exit $LASTEXITCODE)"
  }
}

Write-Host "Done."
