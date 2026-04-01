# RStudio quick working directory (`rstudio.quickwd`)

**Language: English** · **中文说明:** [README-zh.md](README-zh.md) · **Repository:** [github.com/anthonyhtang/rstudio-quick-working-directory](https://github.com/anthonyhtang/rstudio-quick-working-directory)

## Overview

`rstudio.quickwd` registers **two** RStudio add-ins so the **command palette** and **Browse Addins** list two separate actions:

| Add-in (palette name) | What it does |
|----------------------|--------------|
| **Quick working directory — clipboard** | `setwd()` + **Files** from the **clipboard** path (first line). |
| **Quick working directory — active file** | `setwd()` + **Files** from the **active source tab**’s on-disk path (parent folder; **Untitled** has no path). |

Pick whichever matches what you want; there is no automatic switching between them in the UI.

From the **R console**, `quick_working_directory("clipboard")` and `quick_working_directory("active")` match those add-ins. `quick_working_directory()` with no arguments (or `source = "default"`) tries the clipboard first, then the active file — useful in scripts, not registered as an add-in.

---

## Running it in RStudio

Install the package, restart RStudio once. Both add-ins are declared in [`addins.dcf`](rstudio.quickwd/inst/rstudio/addins.dcf):

| Name | Effect |
|------|--------|
| **Quick working directory — clipboard** | Clipboard path only. Details under **Behaviour**. |
| **Quick working directory — active file** | Active tab’s on-disk path only. Details under **Behaviour**. |

| Where | How |
|--------|-----|
| **Tools → Browse Addins…** | Search **clipboard** or **active file**, **Run**. |
| **Toolbar** | **Addins** dropdown (near **Run**). |
| **Command palette** | **Tools → Show Command Palette** — see **Fastest way** below. |

---

## Not a coding library

Do **not** `library()` this in everyday scripts. Install it **once**; after that, run either add-in from the **command palette** (recommended), **Browse Addins**, the toolbar **Addins** menu, or **shortcuts** you assign yourself.

## Requirements

- **RStudio** (uses `rstudioapi`).
- **Windows, macOS, or Linux** — clipboard via [`clipr`](https://CRAN.R-project.org/package=clipr) (required for the **clipboard** add-in and for `quick_working_directory()` default mode).
- **Linux:** if the clipboard is unavailable, install **xclip** or **xsel** (X11) or **wl-clipboard** (Wayland).

Installing this package pulls in **`clipr`** automatically. Other entries you may see under the **clipr** package in the add-in list (e.g. “Output to clipboard”) are unrelated to this package.

## Installation

The R package sources live in the **`rstudio.quickwd/`** directory (same name as the **installed** package).

### Option A — From GitHub (no local paths)

```r
install.packages("remotes")  # if you do not have it yet
remotes::install_github("anthonyhtang/rstudio-quick-working-directory", subdir = "rstudio.quickwd")
```

(Fork? Use `yourname/rstudio-quick-working-directory` instead, or install from the default branch of your fork.)

### Option B — From a local clone (relative path)

1. Clone or download this repository.
2. In RStudio, set the working directory to the **repository root** — the folder that **contains** the `rstudio.quickwd` directory (e.g. **Session → Set Working Directory → Choose Directory…**).
3. Run **one** of the following (both use the **`rstudio.quickwd`** folder relative to your current working directory):

```r
install.packages("rstudio.quickwd", repos = NULL, type = "source")
```

```r
install.packages("remotes")
remotes::install_local("rstudio.quickwd")
```

Do **not** paste a full `C:\...` or `/home/...` path unless you prefer; keeping the session at the repo root and using `"rstudio.quickwd"` is enough.

### After installing

Restart **RStudio**.

### Renamed from the old package / repo

Canonical GitHub repo: **`anthonyhtang/rstudio-quick-working-directory`**. The R package lives in the **`rstudio.quickwd/`** subdirectory. If you previously used the old repo name locally, run `git remote set-url origin https://github.com/anthonyhtang/rstudio-quick-working-directory.git`. Replace older installs of **`rstudio.clipboard.path`** with **`rstudio.quickwd`** as above.

## Daily use

1. **Clipboard:** copy a **folder** or **file** path (only the first line is used if there are several), open the command palette, run **Quick working directory — clipboard**. Quoted paths and a leading UTF-8 BOM are tolerated.
2. **Active file:** focus a source tab whose file **has a path on disk** (not **Untitled**), run **Quick working directory — active file**.

## Fastest way to run the add-ins (keyboard, no mouse)

**Use the Command Palette:** press the shortcut, type a keyword, press **Enter**.

| OS | Default shortcut for **Show Command Palette** |
|----|-----------------------------------------------|
| **Windows / Linux** | **Ctrl+Shift+P** |
| **macOS** | **Cmd+Shift+P** |

You can also open it from the menu: **Tools → Show Command Palette**.

Then search e.g. **`quick working`**, **`clipboard`**, **`active file`**, **`working directory`**.

**If your shortcut is different** (for example you remapped it to **Ctrl+Alt+P**): go to **Tools → Modify Keyboard Shortcuts**, search **`Show Command Palette`**, and use whatever key combination RStudio shows there.

Official overview: [Command Palette – RStudio / Posit](https://docs.posit.co/ide/user/ide/guide/ui/command-palette.html).

## Custom shortcut (optional)

This package does **not** ship default keybindings. To bind your own:

1. **Tools → Modify Keyboard Shortcuts**
2. Search **`Quick working directory`** (or scroll **Addins**) — you should see **clipboard** and **active file** as two rows.
3. Set a **different** shortcut on each row if you want both on the keyboard.

[Custom shortcuts – RStudio / Posit](https://docs.posit.co/ide/user/ide/guide/productivity/custom-shortcuts.html)

## Other ways to run the add-ins

| Method | How |
|--------|-----|
| **Toolbar Addins** | **Addins** on the **main toolbar** (near **Run**) — search **clipboard** or **active file**. |
| **Browse Addins** | **Tools → Browse Addins…** → search **quick working** → **Run** the row you need. |
| **R Console** | `quick_working_directory_clipboard()` / `quick_working_directory_active_file()` — same as the add-ins. `quick_working_directory()` uses clipboard first, else active file (`source = "default"`). |

### Command palette does not show an add-in?

- **Restart RStudio** once after `install_github` so add-ins are rescanned.
- Try **`quick`**, **`clipboard`**, **`active`** (English).
- Reliable path: **Tools → Browse Addins…** → search **Quick working directory** → **Run**.

## Behaviour

After a successful `setwd`, the package sends the same call to the **Console** with `rstudioapi::sendToConsole(..., execute = TRUE)` (falls back to `message()` if that fails), so you see the exact `setwd("...")` line for reference or copy-paste.

### Quick working directory — clipboard

Same as `quick_working_directory("clipboard")` / `quick_working_directory_clipboard()`.

| Clipboard points to | Working directory + Files pane | Open file in editor |
|---------------------|--------------------------------|----------------------|
| Existing directory | That directory | No |
| File with R-ecosystem extension, or `.Rprofile` / `.Renviron` | Parent of the file | Yes |
| Other existing file | Parent of the file | No |

**Extensions treated as “open in editor”** (case-insensitive):  
`r`, `rmd`, `qmd`, `rnw`, `rhtml`, `rd`, `rproj`, `rpres`, `rhistory`, `c`, `cpp`, `cc`, `cxx`, `h`, `hpp`, `f`, `f90`, plus basenames `.Rprofile` and `.Renviron`.

### Quick working directory — active file

Same as `quick_working_directory("active")` / `quick_working_directory_active_file()`.

Uses `rstudioapi::getActiveDocumentContext()` — the **path string** RStudio reports for the **focused source tab**. Working directory becomes the **parent** of that path (or the path itself if it is a directory).

| Situation | Result |
|-----------|--------|
| Active tab has an **on-disk path** that still exists | `setwd()` + Files pane → **parent folder** of that path (or the directory if the tab is a folder path). |
| Active tab is **Untitled** / no path on disk | Error: save the file, or use the **clipboard** add-in instead. |
| Reported path no longer exists on disk | Error. |

Does **not** call `navigateToFile()` here — the document is already open.

### `quick_working_directory()` default (console / scripts only)

Not an add-in. If the clipboard’s first line is a usable path that exists on disk, behaviour matches **clipboard** above; otherwise it matches **active file** above.

## Repository layout

| Path | Purpose |
|------|---------|
| [`rstudio.quickwd/R/quick_wd_addins.R`](rstudio.quickwd/R/quick_wd_addins.R) | Add-in implementation |
| [`rstudio.quickwd/inst/rstudio/addins.dcf`](rstudio.quickwd/inst/rstudio/addins.dcf) | RStudio registration |

## Licence

See [`rstudio.quickwd/LICENSE`](rstudio.quickwd/LICENSE).

## Repository & contributing

**Source:** [github.com/anthonyhtang/rstudio-quick-working-directory](https://github.com/anthonyhtang/rstudio-quick-working-directory)

```bash
git clone https://github.com/anthonyhtang/rstudio-quick-working-directory.git
cd rstudio-quick-working-directory
# edit, then commit and push (default branch: main)
```

## Other distribution outlets (optional)

| Outlet | What it is |
|--------|------------|
| **[CRAN](https://cran.r-project.org/submit.html)** | Official R archive; users run `install.packages("rstudio.quickwd")`. Requires `R CMD check` and policy compliance. |
| **[R-universe](https://r-universe.dev/)** | Builds from GitHub; lighter than CRAN for many small packages. |
| **Posit / RStudio** | No separate add-in store; discovery is usually GitHub, CRAN, blogs, or [Posit Community](https://forum.posit.co/). |
