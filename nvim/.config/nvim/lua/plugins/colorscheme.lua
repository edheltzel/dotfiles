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
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "eldritch",
    },
  },
  -- set ghostty syntax highlighting
  {
    dir = (vim.env.GHOSTTY_RESOURCES_DIR or "") .. "/../vim/vimfiles",
    lazy = false, -- Ensures it loads for Ghostty config detection
    name = "ghostty", -- Avoids the name being "vimfiles"
    cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil, -- Only load if Ghostty is installed
  },
}
