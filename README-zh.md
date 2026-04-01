# RStudio quick working directory（`rstudio.quickwd`）

**语言：中文** · **English:** [README.md](README.md) · **源码仓库：** [github.com/anthonyhtang/rstudio-quick-working-directory](https://github.com/anthonyhtang/rstudio-quick-working-directory)

## 动机（Motivation）

在 RStudio 里**想尽快跑一段脚本或项目**时，最烦人的往往是 **Working Directory（工作目录）**：要点 **Session → Set Working Directory**、手动 `setwd()`，或者把 **Files** 窗格对齐到目标文件夹。本包提供 **两个插件**（品牌：**RStudio quick working directory**）：

1. **Quick WD from clipboard** — 在资源管理器等地方**复制**路径（目录或文件），回到 RStudio，**一个快捷键**运行插件，**wd** 与 **Files** 即与路径对齐。
2. **Quick WD from active file** — 要跑的脚本**已经在编辑器里打开**；运行该插件，工作目录会设为该文件**所在文件夹**（**不经过剪贴板**）。

实现上，包名 **`rstudio.quickwd`**：前者用 **`clipr`** 读剪贴板；后者用 **`rstudioapi::getActiveDocumentContext()`**。前者对常见 **R 相关文件**还可**在编辑器中打开**（见下文 **行为说明**）。

---

## 什么是 RStudio「插件」（Addins）？

很多人**没接触过插件系统**，这里单独说明一下：

- **插件**是 R **包**在安装后向 **RStudio 登记**的一小段可执行功能，**不是**单独的应用商店；装好包、**重启 RStudio** 后，IDE 会自动发现该包声明的插件。
- 本包登记 **两个** 插件（见 [`addins.dcf`](rstudio.quickwd/inst/rstudio/addins.dcf)）：

| 插件名称（英文，与 RStudio 列表一致） | 作用 |
|--------------------------------------|------|
| **Quick WD from clipboard** | **剪贴板**里的路径 → `setwd()` + Files 窗格（必要时打开 R 类文件）。 |
| **Quick WD from active file** | **当前编辑器中已打开的文件**（磁盘路径）→ `setwd()` 到其**所在目录** + Files 窗格。 |

**在 RStudio 里可以从哪里用到插件？**

| 入口 | 位置 |
|------|------|
| **浏览全部插件** | 菜单 **Tools → Browse Addins…**，列表可搜索，选中后点 **Run**。 |
| **工具栏** | 主工具栏 **Addins** 下拉（一般在 **Run** 旁边），带搜索框，通常比每次打开 Browse 更快。 |
| **命令面板** | **Tools → Show Command Palette**，用键盘输入几个字母即可筛选（见下文 **推荐用法**）。 |

---

## 不是日常编程用的「库」

不要在日常脚本里 `library()` 本包。只需**安装一次**；之后任选一个插件，用 **命令面板 + 键盘**、**Browse Addins**、工具栏 **Addins** 或**各自快捷键**调用。

## 环境与依赖

- **RStudio**（依赖 `rstudioapi`）。
- **Windows / macOS / Linux**，剪贴板通过 CRAN 包 **`clipr`**。
- **Linux**：若无法读剪贴板，请安装 **xclip**、**xsel**（X11）或 **wl-clipboard**（Wayland）。

安装本包时会**自动**安装 **`clipr`**（仅 **Quick WD from clipboard** 需要；**Quick WD from active file** 不用剪贴板）。Addins 列表里 **`clipr`** 自带的其它项（如 “Output to clipboard”）与本包无关。

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

以前仓库名为 **`RStudio-set-path`**、R 包名为 **`rstudio.clipboard.path`**。请改装 **`rstudio.quickwd`**，并使用 **`subdir = "rstudio.quickwd"`**。建议在 GitHub 上将仓库改名为 **`rstudio-quick-working-directory`**（**Settings → General → Repository name**），与文档链接一致，并在本地更新 **`git remote`**。

## 日常使用

### A — Quick WD from clipboard（剪贴板）

1. 将**目录或文件**路径复制到剪贴板（多行时只使用首行逻辑）。
2. 运行 **Quick WD from clipboard**（命令面板、Addins 或快捷键）。

支持带引号路径与 UTF-8 BOM。

### B — Quick WD from active file（当前文件）

1. 在**源编辑器**里打开并**聚焦**一个**已保存到磁盘**的文件。
2. 运行 **Quick WD from active file**。

**wd** 与 **Files** 窗格会设为该文件**所在文件夹**。若当前是**未保存的 Untitled**，没有磁盘路径，请先保存，或改用剪贴板插件。

## 推荐用法：命令面板 + 关键字（最快、尽量不用鼠标）

| 系统 | **Show Command Palette** 的默认快捷键 |
|------|----------------------------------------|
| **Windows / Linux** | **Ctrl+Shift+P** |
| **macOS** | **Cmd+Shift+P** |

也可：**Tools → Show Command Palette**。

在面板里可按插件名搜索，例如：

| 插件 | 可尝试输入（英文） |
|------|-------------------|
| **Quick WD from clipboard** | **`quick`**、**`clipboard`**、**`quick wd`** |
| **Quick WD from active file** | **`quick`**、**`active`**、**`set wd`**、**`active file`** |

**若本机打开命令面板的不是 Ctrl+Shift+P**（例如 **Ctrl+Alt+P**）：**Tools → Modify Keyboard Shortcuts** → 搜 **`Show Command Palette`**，以其中显示为准。

说明：[Command Palette（Posit）](https://docs.posit.co/ide/user/ide/guide/ui/command-palette.html)

## 自定义快捷键（可选）

本包**不自带**默认快捷键。可为**两个插件分别**绑定：

1. **Tools → Modify Keyboard Shortcuts**
2. 搜索 **`Quick WD from clipboard`** 或 **`Quick WD from active file`**
3. 在 **快捷键** 格子里各设一组未占用的组合键

参考：[Custom shortcuts（Posit）](https://docs.posit.co/ide/user/ide/guide/productivity/custom-shortcuts.html)

## 其它运行方式

| 方式 | 操作 |
|------|------|
| **工具栏 Addins** | **Addins** → 搜索插件名 → 运行。 |
| **Browse Addins** | **Tools → Browse Addins…** → 搜索 **quick** / **clipboard** / **active** → **Run**。 |
| **R 控制台** | `rstudio.quickwd::quick_wd_from_clipboard()` 或 `rstudio.quickwd::quick_wd_from_active_file()` |

### 命令面板里搜不到？

- **重启 RStudio** 后再试。
- 可试 **`addin`**、**`quick`**、**`clipboard`**、**`active`** 等英文关键词。
- 最稳妥：**Tools → Browse Addins…** 按名称运行。

## 行为说明

### Quick WD from clipboard

| 剪贴板内容 | Working Directory + Files 窗格 | 是否在编辑器打开文件 |
|------------|--------------------------------|----------------------|
| 已存在的目录 | 该目录 | 否 |
| 带 R 常见扩展名的文件，或 `.Rprofile` / `.Renviron` | 该文件所在目录 | 是 |
| 其它已存在文件 | 该文件所在目录 | 否 |

**会在编辑器中打开的文件扩展名**（不区分大小写）：  
`r`, `rmd`, `qmd`, `rnw`, `rhtml`, `rd`, `rproj`, `rpres`, `rhistory`, `c`, `cpp`, `cc`, `cxx`, `h`, `hpp`, `f`, `f90`，以及文件名为 `.Rprofile`、`.Renviron` 的情况。

### Quick WD from active file

| 情况 | 结果 |
|------|------|
| 当前标签是**已保存**的磁盘文件 | `setwd()` + Files → 该文件**所在目录**。 |
| **Untitled** / 未保存 | 报错；请先保存或用剪贴板插件。 |
| 磁盘上已不存在该路径 | 报错。 |

不会在编辑器里再次 `navigateToFile()` — 文件本来已打开。

## 仓库结构

| 路径 | 说明 |
|------|------|
| [`rstudio.quickwd/R/quick_wd_addins.R`](rstudio.quickwd/R/quick_wd_addins.R) | 插件实现代码 |
| [`rstudio.quickwd/inst/rstudio/addins.dcf`](rstudio.quickwd/inst/rstudio/addins.dcf) | RStudio 注册信息 |

## 许可证

见 [`rstudio.quickwd/LICENSE`](rstudio.quickwd/LICENSE)。

## 公开与分发（概要）

- **GitHub**：默认仓库 [anthonyhtang/rstudio-quick-working-directory](https://github.com/anthonyhtang/rstudio-quick-working-directory)；安装命令见上文 **方式 A**。克隆：`git clone https://github.com/anthonyhtang/rstudio-quick-working-directory.git`。更多分发渠道见英文 [README.md](README.md) 末尾。
