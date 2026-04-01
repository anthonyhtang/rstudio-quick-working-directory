# List and delete your GitHub forks

These scripts work on **your** forks (repos under your account where `fork = true`). They do not delete other people’s originals.

## Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`)
- `gh auth login` (same GitHub account whose forks you want to list/delete)

## Steps

1. **List forks** (writes `my-forks-list.txt` in this folder):

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

4. **Dry run** (only prints what would be deleted):

   ```powershell
   .\2-delete-forks-from-list.ps1
   ```

5. **Delete** (irreversible on GitHub’s side):

   ```powershell
   .\2-delete-forks-from-list.ps1 -ConfirmDeletion
   ```

## Notes

- Default fork list limit is **1000**. If you have more, extend `1-list-my-forks.ps1` (e.g. use `gh api user/repos --paginate` with a `jq` filter on `.fork`).
- Deletion uses `gh repo delete <repo> --yes`. You must have permission to delete those repositories (you own them).
