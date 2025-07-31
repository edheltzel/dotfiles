-- https://github.com/craftzdog/solarized-osaka.nvim
return {
  {
    "craftzdog/solarized-osaka.nvim",
    name = "solarized-osaka",
    priority = 1000,
    lazy = false,
    opts = {
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
    end,
  },
}
