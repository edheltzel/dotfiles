return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local km = require("neoed.core.keymap-utils")

      -- Navigation
      km.buffer_map(bufnr, "n", "]h", gs.next_hunk, "Next Hunk")
      km.buffer_map(bufnr, "n", "[h", gs.prev_hunk, "Prev Hunk")

      -- Actions
      km.buffer_map(bufnr, "n", "<leader>hs", gs.stage_hunk, "Stage hunk")
      km.buffer_map(bufnr, "n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      km.buffer_map(bufnr, "v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      km.buffer_map(bufnr, "v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")

      km.buffer_map(bufnr, "n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      km.buffer_map(bufnr, "n", "<leader>hR", gs.reset_buffer, "Reset buffer")

      km.buffer_map(bufnr, "n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

      km.buffer_map(bufnr, "n", "<leader>hp", gs.preview_hunk, "Preview hunk")

      km.buffer_map(bufnr, "n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      km.buffer_map(bufnr, "n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

      km.buffer_map(bufnr, "n", "<leader>hd", gs.diffthis, "Diff this")
      km.buffer_map(bufnr, "n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff this ~")

      -- Text object
      km.buffer_map(bufnr, { "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}
