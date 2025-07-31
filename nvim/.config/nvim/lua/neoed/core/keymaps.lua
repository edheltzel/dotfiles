vim.g.mapleader = " "

local km = require("neoed.core.keymap-utils")

-- Setup common which-key groups
km.setup_common_groups()

-- Core keymaps organized by category
local core_keymaps = {
  -- Basic editing
  {
    { "i", "jk", "<ESC>", { desc = "Exit insert mode with jk" } },
    { "n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" } },
    { { "n", "v" }, "<leader>fS", ":write<CR>", { desc = "Save changes" } },
  },
  
  -- Navigation
  {
    { "n", "gh", "^", { desc = "Jump beginning of line" } },
    { "n", "gl", "$", { desc = "Jump end of line" } },
  },
  
  -- Window management
  {
    { "n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" } },
    { "n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" } },
    { "n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" } },
    { "n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" } },
  },
  
  -- Tab management
  {
    { "n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" } },
    { "n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" } },
    { "n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" } },
    { "n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" } },
    { "n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" } },
  },
  
  -- Visual mode editing
  {
    { "v", "<", "<gv", { desc = "Indent left and reselect" } },
    { "v", ">", ">gv", { desc = "Indent right and reselect" } },
  },
}

-- Register all keymaps
for _, group in ipairs(core_keymaps) do
  km.register_keymaps(group)
end

-- Register groups with which-key
km.register_groups()
