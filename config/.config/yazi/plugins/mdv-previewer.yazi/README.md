<h1 align="center">📖mdv-previewer.yazi</h1>
<p align="center">
  <b>Fast, themeable Markdown viewer for the terminal</b><br>
  <i>View Markdown without leaving yazi</i>
</p>

https://github.com/user-attachments/assets/a624a333-7627-4961-ac73-e6e81bd536d2

> [!TIP]
> **Russian version:** [README-RU.md](README-RU.md)

> [!IMPORTANT]
> Requires Yazi v25.5.28+\
> Requires [`mdv`](https://github.com/WhoSowSee/mdv) in `PATH`

## Installation

```sh
ya pkg add WhoSowSee/mdv-previewer
```

```sh
# Manual installation

# Linux / macOS
git clone https://github.com/WhoSowSee/mdv-previewer.yazi.git ~/.config/yazi/plugins/mdv-previewer.yazi

# Windows
git clone https://github.com/WhoSowSee/mdv-previewer.yazi.git "$env:APPDATA\yazi\config\plugins\mdv-previewer.yazi"
```

## Usage

### Register the previewer

Add the plugin to `yazi.toml` (adjust the masks if necessary):

```toml
[[plugin.prepend_previewers]]
url = "*.{md,markdown,txt}"
run = "mdv-previewer"

[[plugin.prepend_preloaders]]
url = "*.{md,markdown,txt}"
run = "mdv-previewer"
```

### Configure options (optional)

Example block in `init.lua`:

```lua
require("mdv-previewer"):setup({
  theme = "kanagawa",
  code_theme = "tokyonight",

  -- It is not recommended to use this parameter
  -- If not specified, uses the default safe arguments
  -- Cannot use -m/--monitor, -H/--html, --config-file, -h/--help, -V/--version, -G/--init-config, and -p/--pager
  -- The priority of custom_args is higher than theme and code_theme
  custom_args = {
    "--cols", "64",
    "--custom-theme", "h1=173,22,124",
  },

  -- Number of lines per scroll step. Can take "auto" to use the default value
  scroll_step = 3,
})
```

## Star History

<p align="center">
  <a href="https://starchart.cc/WhoSowSee/mdv-previewer.yazi">
    <picture>
      <source
        media="(prefers-color-scheme: dark)"
        srcset="https://starchart.cc/WhoSowSee/mdv-previewer.yazi.svg?variant=custom&background=%230d1117&axis=%238b949e&line=%232f81f7"
      />
      <source
        media="(prefers-color-scheme: light)"
        srcset="https://starchart.cc/WhoSowSee/mdv-previewer.yazi.svg?variant=custom&background=%23ffffff&axis=%2357606a&line=%230969da"
      />
      <img
        alt="История звёзд"
        src="https://starchart.cc/WhoSowSee/mdv-previewer.yazi.svg?variant=custom&background=%23ffffff&axis=%2357606a&line=%230969da"
      />
    </picture>
  </a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" alt="catppuccin" />
</p>

<p align="center">
  <i><code>&copy 2026-present <a href="https://github.com/WhoSowSee">WhoSowSee</a></code></i>
</p>

<p align="center">
  <a href="https://github.com/WhoSowSee/mdv-previewer.yazi/blob/main/LICENSE"><img src="https://img.shields.io/github/license/WhoSowSee/mdv?style=for-the-badge&color=CBA6F7&logoColor=cdd6f4&labelColor=302D41" alt="LICENSE"></a>
</p>
