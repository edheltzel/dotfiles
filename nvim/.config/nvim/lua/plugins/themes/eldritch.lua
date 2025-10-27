-- https://github.com/eldritch-theme/eldritch.nvim
-- I also contrubite to the vscode theme https://github.com/eldritch-theme/vscode
return {
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      palette = "dark",
      transparent = false,
      dim_inactive = true,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = {
        "qf",
        "help",
        "terminal",
      },
    },
  },
}
