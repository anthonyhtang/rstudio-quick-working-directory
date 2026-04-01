# List and delete your GitHub forks (public forks only)

These scripts only deal with repositories that are **forks** of someone else’s project (`fork = true` on GitHub). **Your own originals are never listed** — they are not forks.

They also **never list or delete private (or internal) forks**. Only **public** forks appear in `my-forks-list.txt`, and the delete script **double-checks** each line with `gh repo view` and **skips** anything that is private, internal, or not a fork.

## Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`)
- `gh auth login` (same GitHub account whose forks you want to list/delete)

## Steps

1. **List public forks** (writes `my-forks-list.txt` in this folder):

   ```powershell
   cd scripts\github-forks
   .\1-list-my-forks.ps1
   ```

2. **Review** `my-forks-list.txt`. Remove any fork you want to **keep**.

3. **Save the remainder** as `forks-to-delete.txt` in this folder (same format: one `owner/repo` per line).  
   You can copy/rename:

   ```powershell
   Copy-Item my-forks-list.txt forks-to-delete.txt
   notepad forks-to-delete.txt   # delete lines to keep
   ```

4. **Dry run** (checks each repo; shows what would be deleted):

   ```powershell
   .\2-delete-forks-from-list.ps1
   ```

5. **Delete** (irreversible on GitHub’s side):

   ```powershell
   .\2-delete-forks-from-list.ps1 -ConfirmDeletion
   ```

## Safety rules (built in)

| Rule | How |
|------|-----|
| No **private** forks | Excluded when listing; delete script skips if still private. |
| No **internal** visibility (e.g. some orgs) | Excluded when listing; skipped on delete. |
| Not a **fork** (your own repo) | Never in `gh repo list --fork`; delete script refuses if `isFork` is false. |

## Notes

- Default fork list limit is **1000**. If you have more public forks, extend `1-list-my-forks.ps1` (e.g. `gh api user/repos --paginate` with filters).
- Deletion uses `gh repo delete <repo> --yes`. You must have permission to delete those repositories (you own them).
