-- https://github.com/rose-pine/neovim

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
      dark_variant = "main",
      dim_inactive_windows = true,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
      },
      styles = {
        transparency = false, -- transparency is cool but my eyes are getting old
        bold = true,
        italic = false,
      },
    },
  },
}
