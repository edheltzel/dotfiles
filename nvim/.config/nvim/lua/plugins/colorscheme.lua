return {
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "night",
    },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = function(_, opts)
      opts.transparent = true
      opts.italic_comments = true
      opts.styles = {
        sidebar = "transparent",
        floats = "dark",
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "eldritch",
    },
  },
}
