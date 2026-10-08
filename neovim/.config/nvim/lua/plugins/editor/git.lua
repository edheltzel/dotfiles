return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "󰾗 " },
        change = { text = "󰯔 " },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signs_staged = {
        add = { text = "󱔲 " },
        change = { text = "󱔲 " },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      lazygit = {
        configure = false,
      },
    },
  },
}
