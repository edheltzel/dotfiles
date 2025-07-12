return {
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
  -- set colorscheme/theme
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "eldritch",
  --   },
  -- },
}
