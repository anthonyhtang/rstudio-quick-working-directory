# Lists PUBLIC forks only under your GitHub user (fork = true, not your originals).
# Excludes: private repos, internal repos, and anything that is not a fork.
# Requires: GitHub CLI — https://cli.github.com/ — and `gh auth login`
#
# Usage (PowerShell):
#   cd scripts\github-forks
#   .\1-list-my-forks.ps1
#
# Output: my-forks-list.txt (one "owner/repo" per line)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "Install GitHub CLI: https://cli.github.com/  Then run: gh auth login"
}

$outFile = Join-Path $PSScriptRoot "my-forks-list.txt"

# --fork: GitHub only returns repos created with "Fork" (never your own non-fork repos).
# We still filter in PowerShell on isFork + visibility for safety.
$json = gh repo list "@me" --fork --limit 1000 --json nameWithOwner,isFork,isPrivate,visibility 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Error "gh repo list failed. Run: gh auth login"
}

$items = $json | ConvertFrom-Json
if ($null -eq $items) {
  Set-Content -Path $outFile -Value "" -Encoding utf8
  Write-Host "No matching repositories."
  exit 0
}

# Single object vs array
if ($items -isnot [System.Array]) {
  $items = @($items)
}

$repos = foreach ($row in $items) {
  if ($row.isFork -ne $true) { continue }
  if ($row.isPrivate -eq $true) { continue }
  $vis = $row.visibility
  if ($vis -in @("PRIVATE", "INTERNAL")) { continue }
  $row.nameWithOwner
}

$repos = $repos | Sort-Object -Unique

if (-not $repos) {
  Write-Host "No public fork repositories found (after filtering private / non-fork)."
  Set-Content -Path $outFile -Value "" -Encoding utf8
  exit 0
}

Set-Content -Path $outFile -Value ($repos -join "`n") -Encoding utf8
Write-Host "Wrote $($repos.Count) public fork(s) to:"
Write-Host "  $outFile"
Write-Host "(Private forks and non-fork repos are never listed.)"
Write-Host ""
Write-Host "Next: review the file, remove any repo you want to KEEP, save as:"
Write-Host "  forks-to-delete.txt"
Write-Host "Then run: .\2-delete-forks-from-list.ps1 -ConfirmDeletion"
