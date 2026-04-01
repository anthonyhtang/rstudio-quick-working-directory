# RStudio clipboard path (`rstudio.clipboard.path`)

**Language: English** · **中文说明:** [README-zh.md](README-zh.md) · **Repository:** [github.com/anthonyhtang/RStudio-set-path](https://github.com/anthonyhtang/RStudio-set-path)

## Motivation

When you want to **run something quickly** in RStudio, the **working directory** is often the most tedious part: digging through **Session → Set Working Directory**, typing `setwd()`, or lining up the **Files** pane with the folder you care about. This package offers **two add-ins** for that:

1. **RStudio clipboard path** — **copy** a path (folder or file) from Explorer or elsewhere, switch to RStudio, and run the add-in with **one shortcut**; `setwd()` and the **Files** pane update to match.
2. **Set WD from active file** — the script you care about is **already open** in the editor; run this add-in and the working directory becomes that file’s **folder** (no clipboard).

Technically, **`rstudio.clipboard.path`** implements both: the first reads the **clipboard** (via **`clipr`**); the second uses **`rstudioapi::getActiveDocumentContext()`** on the active source document. The clipboard add-in can also **open** common R-related files in the editor (see **Behaviour** below).

---

## What are RStudio add-ins? (if you are new to this)

**Add-ins** are small actions that an R **package** can register with **RStudio** after you install the package. They are **not** a separate app store: you install a normal R package, restart RStudio, and the IDE picks up whatever add-ins that package declares.

**Where you can run add-ins in RStudio**

| Place | Menu / UI |
|--------|-----------|
| **Browse list** | **Tools → Browse Addins…** — searchable list of every add-in from installed packages; click **Run**. |
| **Toolbar** | The **Addins** dropdown on the **main toolbar** (near **Run**) — same list, often faster than opening the full dialog. |
| **Command palette** | **Tools → Show Command Palette** (see **Fastest way to run this add-in** below) — type a few letters of the name. |

This package registers **two** add-ins (see [`addins.dcf`](rstudio.clipboard.path/inst/rstudio/addins.dcf)):

| Add-in name | What it does |
|-------------|----------------|
| **RStudio clipboard path** | Path from **clipboard** → `setwd()` + Files pane (+ open R-style files if applicable). |
| **Set WD from active file** | **Active editor file** on disk → `setwd()` to its parent folder + Files pane. |

---

## Not a coding library

Do **not** `library()` this in everyday scripts. Install it **once**; after that, run either add-in from the **command palette** (recommended), **Browse Addins**, the toolbar **Addins** menu, or **shortcuts** you assign yourself.

## Requirements

- **RStudio** (uses `rstudioapi`).
- **Windows, macOS, or Linux** — clipboard via [`clipr`](https://CRAN.R-project.org/package=clipr).
- **Linux:** if the clipboard is unavailable, install **xclip** or **xsel** (X11) or **wl-clipboard** (Wayland).

Installing this package pulls in **`clipr`** automatically (needed for the **clipboard** add-in only; **Set WD from active file** does not use the clipboard). Other entries you may see under the **clipr** package in the add-in list (e.g. “Output to clipboard”) are unrelated to this package.

## Installation

The R package sources live in the **`rstudio.clipboard.path/`** directory (same name as the **installed** package).

### Option A — From GitHub (no local paths)

```r
install.packages("remotes")  # if you do not have it yet
remotes::install_github("anthonyhtang/RStudio-set-path", subdir = "rstudio.clipboard.path")
```

(Fork? Use `yourname/RStudio-set-path` instead, or install from the default branch of your fork.)

### Option B — From a local clone (relative path)

1. Clone or download this repository.
2. In RStudio, set the working directory to the **repository root** — the folder that **contains** the `rstudio.clipboard.path` directory (e.g. **Session → Set Working Directory → Choose Directory…**).
3. Run **one** of the following (both use the **`rstudio.clipboard.path`** folder relative to your current working directory):

```r
install.packages("rstudio.clipboard.path", repos = NULL, type = "source")
```

```r
install.packages("remotes")
remotes::install_local("rstudio.clipboard.path")
```

Do **not** paste a full `C:\...` or `/home/...` path unless you prefer; keeping the session at the repo root and using `"rstudio.clipboard.path"` is enough.

### After installing

Restart **RStudio**.

## Daily use

### A — RStudio clipboard path

1. Copy a **folder** or **file** path to the clipboard (only the first line is used if there are several).
2. Run **RStudio clipboard path** (command palette, Addins menu, or shortcut).

Quoted paths and a leading UTF-8 BOM are tolerated.

### B — Set WD from active file

1. Open a file **from disk** in the source editor (focus that tab).
2. Run **Set WD from active file**.

The session **working directory** and **Files** pane become that file’s **parent folder**. **Unsaved “Untitled” buffers** have no path — save the file first, or use the clipboard add-in instead.

## Fastest way to run the add-ins (keyboard, no mouse)

**Use the Command Palette:** press the shortcut, type a keyword, press **Enter**. You do **not** need to reach for **Browse Addins** every time.

| OS | Default shortcut for **Show Command Palette** |
|----|-----------------------------------------------|
| **Windows / Linux** | **Ctrl+Shift+P** |
| **macOS** | **Cmd+Shift+P** |

You can also open it from the menu: **Tools → Show Command Palette**.

Then search by add-in name, for example:

| Add-in | Try typing in the palette |
|--------|---------------------------|
| **RStudio clipboard path** | **`clipboard`**, **`RStudio clipboard`** |
| **Set WD from active file** | **`active`**, **`set wd`**, **`active file`** |

**If your shortcut is different** (for example you remapped it to **Ctrl+Alt+P**): go to **Tools → Modify Keyboard Shortcuts**, search **`Show Command Palette`**, and use whatever key combination RStudio shows there — that opens the same palette.

Official overview: [Command Palette – RStudio / Posit](https://docs.posit.co/ide/user/ide/guide/ui/command-palette.html).

## Custom shortcut (optional)

This package does **not** ship default keybindings. To bind your own:

1. **Tools → Modify Keyboard Shortcuts**
2. Search **`RStudio clipboard path`** or **`Set WD from active file`** (or scroll the **Addins** section)
3. Click the **Shortcut** cell for that row and press any **unused** key combination (e.g. **Ctrl+Alt+Y** for one, another combo for the other)

[Custom shortcuts – RStudio / Posit](https://docs.posit.co/ide/user/ide/guide/productivity/custom-shortcuts.html)

## Other ways to run the add-ins

| Method | How |
|--------|-----|
| **Toolbar Addins** | **Addins** on the **main toolbar** (near **Run**) — search box, pick the add-in. |
| **Browse Addins** | **Tools → Browse Addins…** → search **clipboard** or **active** → **Run**. |
| **R Console** | `rstudio.clipboard.path::sync_path_from_clipboard()` or `rstudio.clipboard.path::sync_wd_from_active_file()` |

### Command palette does not show an add-in?

- **Restart RStudio** once after `install_github` so add-ins are rescanned.
- The palette is **not** the VS Code palette: it only lists what your **RStudio build** indexes. Try **`addin`**, **`clipboard`**, **`active`**, **`set wd`** (English).
- Reliable path: **Tools → Browse Addins…** → search by name → **Run**.
- Or bind shortcuts: **Tools → Modify Keyboard Shortcuts** → search each add-in name.

## Behaviour

### RStudio clipboard path

| Clipboard points to | Working directory + Files pane | Open file in editor |
|---------------------|--------------------------------|----------------------|
| Existing directory | That directory | No |
| File with R-ecosystem extension, or `.Rprofile` / `.Renviron` | Parent of the file | Yes |
| Other existing file | Parent of the file | No |

**Extensions treated as “open in editor”** (case-insensitive):  
`r`, `rmd`, `qmd`, `rnw`, `rhtml`, `rd`, `rproj`, `rpres`, `rhistory`, `c`, `cpp`, `cc`, `cxx`, `h`, `hpp`, `f`, `f90`, plus basenames `.Rprofile` and `.Renviron`.

### Set WD from active file

| Situation | Result |
|-----------|--------|
| Active tab is a **saved file** on disk | `setwd()` + Files pane → **parent folder** of that file. |
| Active tab is **Untitled** / not saved | Error: save the file or use the clipboard add-in. |
| Path no longer exists on disk | Error. |

Does **not** call `navigateToFile()` — the document is already open.

## Repository layout

| Path | Purpose |
|------|---------|
| [`rstudio.clipboard.path/R/sync_path_from_clipboard.R`](rstudio.clipboard.path/R/sync_path_from_clipboard.R) | Add-in implementation |
| [`rstudio.clipboard.path/inst/rstudio/addins.dcf`](rstudio.clipboard.path/inst/rstudio/addins.dcf) | RStudio registration |

## Licence

See [`rstudio.clipboard.path/LICENSE`](rstudio.clipboard.path/LICENSE).

## Repository & contributing

**Source:** [github.com/anthonyhtang/RStudio-set-path](https://github.com/anthonyhtang/RStudio-set-path)

```bash
git clone https://github.com/anthonyhtang/RStudio-set-path.git
cd RStudio-set-path
# edit, then commit and push (default branch: main)
```

## Other distribution outlets (optional)

| Outlet | What it is |
|--------|------------|
| **[CRAN](https://cran.r-project.org/submit.html)** | Official R archive; users run `install.packages("rstudio.clipboard.path")`. Requires `R CMD check` and policy compliance. |
| **[R-universe](https://r-universe.dev/)** | Builds from GitHub; lighter than CRAN for many small packages. |
| **Posit / RStudio** | No separate add-in store; discovery is usually GitHub, CRAN, blogs, or [Posit Community](https://forum.posit.co/). |
