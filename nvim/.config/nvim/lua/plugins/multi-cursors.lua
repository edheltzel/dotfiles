return {
  -- "smoka7/multicursors.nvim",
  -- event = "VeryLazy",
  -- dependencies = {
  --   "nvimtools/hydra.nvim",
  -- },
  -- opts = {},
  -- cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  -- keys = {
  --   {
  --     mode = { "v", "n" },
  --     "<Leader>m",
  --     "<cmd>MCstart<cr>",
  --     desc = "Create a selection for selected text or word under the cursor",
  --   },
  -- },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    keys = {
      -- { "<C-n>", ":MultiCursorsNext<cr>", desc = "Move to the next cursor" },
    },
  },
}
