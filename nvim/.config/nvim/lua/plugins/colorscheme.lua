return {
  -- Eldritch theme
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      palette = "default",
      transparent = true,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = {
        "qf",
        "help",
        "terminal",
      },
      dim_inactive = true,
    },
  },
  -- Rose Pine theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main",
      dark_variant = "main",
      dim_inactive_windows = true,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
      },
      styles = {
        transparency = true,
        bold = true,
        italic = false,
      },
    },
  },
  -- set colorscheme/theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
