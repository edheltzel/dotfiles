return {
  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    lazy = false,
    opts = {
      transparent_mode = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
    end,
  },
  -- Eldritch
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

  -- Solarized Osaka
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

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    opts = {
      variant = "main",
      dark_variant = "main",
      enable = {
        terminal = true,
      },
      styles = {
        transparency = true,
        bold = false,
        italic = false,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
    end,
  },

  --  Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },

  -- Tokyonight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    lazy = false,
    opts = {
      style = "storm",
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },

  -- Set your default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
