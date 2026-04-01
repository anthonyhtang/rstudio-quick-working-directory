# Lists all repositories under your GitHub user that are forks (owner = you, fork = true).
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

# --fork: only forks; @me: authenticated user; raise limit if you have many forks
$json = gh repo list "@me" --fork --limit 1000 --json nameWithOwner 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Error "gh repo list failed. Run: gh auth login"
}

$repos = $json | ConvertFrom-Json | ForEach-Object { $_.nameWithOwner }
$repos = $repos | Sort-Object -Unique

if (-not $repos) {
  Write-Host "No fork repositories found (or empty result)."
  Set-Content -Path $outFile -Value "" -Encoding utf8
  exit 0
}

Set-Content -Path $outFile -Value ($repos -join "`n") -Encoding utf8
Write-Host "Wrote $($repos.Count) fork(s) to:"
Write-Host "  $outFile"
Write-Host ""
Write-Host "Next: review the file, remove any repo you want to KEEP, save as:"
Write-Host "  forks-to-delete.txt"
Write-Host "Then run: .\2-delete-forks-from-list.ps1 -ConfirmDeletion"
