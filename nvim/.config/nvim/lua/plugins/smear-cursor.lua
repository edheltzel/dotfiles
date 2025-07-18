return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = vim.neovide == nil,
  opts = {
    hide_target_hack = true,
    cursor_color = "#37F499",
    -- faster smear
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    damping = 0.8,
    stiffness_insert_mode = 0.7,
    trailing_stiffness_insert_mode = 0.7,
    damping_insert_mode = 0.8,
    distance_stop_animating = 0.5,
  },
}
