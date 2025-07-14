return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = vim.neovide == nil,
  opts = {
    hide_target_hack = true,
    cursor_color = "#37F499",
  },
}
