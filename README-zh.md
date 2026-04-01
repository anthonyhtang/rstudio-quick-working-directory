# RStudio quick working directory（`rstudio.quickwd`）

**语言：中文** · **English:** [README.md](README.md) · **源码仓库：** [github.com/anthonyhtang/rstudio-quick-working-directory](https://github.com/anthonyhtang/rstudio-quick-working-directory)

## 概述

`rstudio.quickwd` 向 RStudio 登记 **两个** 插件，**命令面板**和 **Browse Addins** 里会列出两条、互不混淆：

| 插件名（英文，与 RStudio 一致） | 作用 |
|--------------------------------|------|
| **Quick working directory — clipboard** | 只用**剪贴板**路径（首行）更新 `setwd()` 与 **Files**。 |
| **Quick working directory — active file** | 只用**当前源标签页**的磁盘路径（父目录）；**Untitled** 无路径。 |

需要哪个就选哪条，**不会在界面里自动在剪贴板与当前文件之间切换**。

**R 控制台**里：`quick_working_directory("clipboard")` / `quick_working_directory("active")` 与上面对应。无参的 `quick_working_directory()`（即 `source = "default"`）会先试剪贴板再试当前文件，适合写在脚本里，**未**登记为插件。

---

## 在 RStudio 里运行

装好本包后**重启一次 RStudio**。两条插件均在 [`addins.dcf`](rstudio.quickwd/inst/rstudio/addins.dcf)：

| 名称 | 作用 |
|------|------|
| **Quick working directory — clipboard** | 仅剪贴板。细则见 **行为说明**。 |
| **Quick working directory — active file** | 仅当前活动标签页磁盘路径。细则见 **行为说明**。 |

| 入口 | 操作 |
|------|------|
| **Tools → Browse Addins…** | 搜 **clipboard** 或 **active file**，**Run**。 |
| **工具栏** | **Addins** 下拉（**Run** 附近）。 |
| **命令面板** | **Tools → Show Command Palette**；参见下文 **推荐用法**。 |

---

## 不是日常编程用的「库」

不要在日常脚本里 `library()` 本包。只需**安装一次**；之后用 **命令面板**、**Browse Addins**、工具栏 **Addins** 或**快捷键**调用**对应**的那一条插件。

## 环境与依赖

- **RStudio**（依赖 `rstudioapi`）。
- **Windows / macOS / Linux**，剪贴板通过 CRAN 包 **`clipr`**（**clipboard** 插件及无参 `quick_working_directory()` 会用到）。
- **Linux**：若无法读剪贴板，请安装 **xclip**、**xsel**（X11）或 **wl-clipboard**（Wayland）。

安装本包时会**自动**安装 **`clipr`**。Addins 列表里 **`clipr`** 自带的其它项（如 “Output to clipboard”）与本包无关。

## 安装说明

插件源码在仓库的 **`rstudio.quickwd/`** 目录下（与 R 安装后的包名一致）。

### 方式 A — 从 GitHub 安装（无需本地路径）

```r
install.packages("remotes")  # 若尚未安装
remotes::install_github("anthonyhtang/rstudio-quick-working-directory", subdir = "rstudio.quickwd")
```

（若你 fork 了本仓库，把上面的 `anthonyhtang/rstudio-quick-working-directory` 换成 `你的用户名/仓库名`。）

### 方式 B — 从本地克隆安装（使用相对路径）

1. 克隆或下载本仓库到本机任意位置。
2. 在 RStudio 中，把**工作目录**设为**仓库根目录**（即**包含** `rstudio.quickwd` 文件夹的那一层）。可用 **Session → Set Working Directory → Choose Directory…**。
3. 在控制台执行**下面任选其一**（`"rstudio.quickwd"` 相对于**当前工作目录**）：

```r
install.packages("rstudio.quickwd", repos = NULL, type = "source")
```

```r
install.packages("remotes")
remotes::install_local("rstudio.quickwd")
```

### 安装之后

**重启 RStudio**。

### 从旧仓库 / 旧包名迁移

GitHub 仓库：**`anthonyhtang/rstudio-quick-working-directory`**，R 包在其中的 **`rstudio.quickwd/`** 目录。若本地克隆曾指向旧仓库名，请执行 **`git remote set-url origin https://github.com/anthonyhtang/rstudio-quick-working-directory.git`**。若仍装着旧 R 包 **`rstudio.clipboard.path`**，请改装 **`rstudio.quickwd`** 并使用 **`subdir = "rstudio.quickwd"`**。

## 日常使用

1. **剪贴板：** 复制**目录或文件**路径（多行时只取首行逻辑），打开命令面板，运行 **Quick working directory — clipboard**。支持带引号路径与 UTF-8 BOM。
2. **当前文件：** 在编辑器里**聚焦**已有**磁盘路径**的标签页（非 **Untitled**），运行 **Quick working directory — active file**。

## 推荐用法：命令面板 + 关键字（最快、尽量不用鼠标）

| 系统 | **Show Command Palette** 的默认快捷键 |
|------|----------------------------------------|
| **Windows / Linux** | **Ctrl+Shift+P** |
| **macOS** | **Cmd+Shift+P** |

也可：**Tools → Show Command Palette**。

在面板里可搜索，例如：**`quick working`**、**`clipboard`**、**`active file`**、**`working directory`**。

**若本机打开命令面板的不是 Ctrl+Shift+P**（例如 **Ctrl+Alt+P**）：**Tools → Modify Keyboard Shortcuts** → 搜 **`Show Command Palette`**，以其中显示为准。

说明：[Command Palette（Posit）](https://docs.posit.co/ide/user/ide/guide/ui/command-palette.html)

## 自定义快捷键（可选）

本包**不自带**默认快捷键。

1. **Tools → Modify Keyboard Shortcuts**
2. 搜索 **`Quick working directory`**（**Addins** 里会有 **clipboard** 与 **active file** 两行）
3. 可分别为两行设置不同快捷键

参考：[Custom shortcuts（Posit）](https://docs.posit.co/ide/user/ide/guide/productivity/custom-shortcuts.html)

## 其它运行方式

| 方式 | 操作 |
|------|------|
| **工具栏 Addins** | **Addins** → 搜 **clipboard** 或 **active file**。 |
| **Browse Addins** | **Tools → Browse Addins…** → 搜 **quick working** → 选需要的行 **Run**。 |
| **R 控制台** | `quick_working_directory_clipboard()` / `quick_working_directory_active_file()` 与两条插件一致。`quick_working_directory()` 为先剪贴板、再当前文件（`source = "default"`）。 |

### 命令面板里搜不到？

- **重启 RStudio** 后再试。
- 可试 **`quick`**、**`clipboard`**、**`active`** 等英文关键词。
- 最稳妥：**Tools → Browse Addins…** → 搜 **Quick working directory** → **Run**。

## 行为说明

成功 `setwd` 之后，会用 `rstudioapi::sendToConsole(..., execute = TRUE)` 在 **Console** 里再执行同一行 `setwd("...")`（失败则 `message()`），便于对照或复制。

### Quick working directory — clipboard

与 `quick_working_directory("clipboard")` / `quick_working_directory_clipboard()` 相同。

| 剪贴板内容 | Working Directory + Files 窗格 | 是否在编辑器打开文件 |
|------------|--------------------------------|----------------------|
| 已存在的目录 | 该目录 | 否 |
| 带 R 常见扩展名的文件，或 `.Rprofile` / `.Renviron` | 该文件所在目录 | 是 |
| 其它已存在文件 | 该文件所在目录 | 否 |

**会在编辑器中打开的文件扩展名**（不区分大小写）：  
`r`, `rmd`, `qmd`, `rnw`, `rhtml`, `rd`, `rproj`, `rpres`, `rhistory`, `c`, `cpp`, `cc`, `cxx`, `h`, `hpp`, `f`, `f90`，以及文件名为 `.Rprofile`、`.Renviron` 的情况。

### Quick working directory — active file

与 `quick_working_directory("active")` / `quick_working_directory_active_file()` 相同。

依据 `rstudioapi::getActiveDocumentContext()`：使用 RStudio 为**当前聚焦源标签页**返回的**路径字符串**（磁盘上的实际路径，须仍存在）。工作目录设为该路径的**父目录**（若该路径本身是目录，则设为该目录）。

| 情况 | 结果 |
|------|------|
| 当前标签有**磁盘路径**且路径仍存在 | `setwd()` + Files → 该路径的**父目录**（路径为目录时则为该目录）。 |
| **Untitled** / 无磁盘路径 | 报错；请先存盘，或改用 **clipboard** 插件。 |
| RStudio 给出的路径在磁盘上已不存在 | 报错。 |

不会在编辑器里再次 `navigateToFile()` — 文件本来已打开。

### 无参 `quick_working_directory()`（仅控制台 / 脚本）

未登记为插件。若剪贴板首行为可用且存在的路径，行为同上文 **clipboard**；否则同 **active file**。

## 仓库结构

| 路径 | 说明 |
|------|------|
| [`rstudio.quickwd/R/quick_wd_addins.R`](rstudio.quickwd/R/quick_wd_addins.R) | 插件实现代码 |
| [`rstudio.quickwd/inst/rstudio/addins.dcf`](rstudio.quickwd/inst/rstudio/addins.dcf) | RStudio 注册信息 |

## 许可证

见 [`rstudio.quickwd/LICENSE`](rstudio.quickwd/LICENSE)。

## 公开与分发（概要）

- **GitHub**：[anthonyhtang/rstudio-quick-working-directory](https://github.com/anthonyhtang/rstudio-quick-working-directory)；安装命令见上文 **方式 A**。克隆：`git clone https://github.com/anthonyhtang/rstudio-quick-working-directory.git`。更多分发渠道见英文 [README.md](README.md) 末尾。
