-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- KEY:
-- <M> = alt
-- <C> = ctrl
-- <leader> = space
-- <s> = shift

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

-- BORDERLESS TERMINAL - LIKE VSCODE
vim.keymap.set({ "n", "t" }, "<C-`>", function()
  Util.terminal(nil, { border = "none" })
end, { desc = "Toggle terminal" })

vim.keymap.set("n", "<D-z>", function()
  Util.terminal(nil, { border = "none" })
end, { desc = "Terminal with Cmd+z" })

-- BORDERLESS LAZYGIT
vim.keymap.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })

keymap.del({ "n", "i", "v" }, "<A-j>")
keymap.del({ "n", "i", "v" }, "<A-k>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Right>")

-- CLEAR SEARCH HIGHLIGHTS
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- JUMP to BOL/EOL
keymap.set("n", "gh", "^", { desc = "Jump beginning of line" })
keymap.set("n", "gl", "$", { desc = "Jump end of line" })

local set_keymap = vim.api.nvim_set_keymap

-- SPLIT WINDOWS
keymap.set("n", "ss", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)

-- tABS
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- VSpaceCode KEYMAPS - VSCODE-ish
keymap.set("n", "<leader>fs", "<cmd>w<cr>", { noremap = true, desc = "Save file" }) -- Save file - VSpaceCode
keymap.set("n", "<ENTER>", "za", { desc = "Code Folding" }) -- Code Folding

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close active tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })

-- FLASH.NVIM KEYMAPS
keymap.set({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, { desc = "Flash" })

-- PACKAGE-INFO KEYMAPS
set_keymap(
  "n",
  "<leader>cpt",
  "<cmd>ua require('package-info').toggle()<cr>",
  { silent = true, noremap = true, desc = "Toggle" }
)
set_keymap(
  "n",
  "<leader>cpd",
  "<cmd>lua require('package-info').delete()<cr>",
  { silent = true, noremap = true, desc = "Delete package" }
)
set_keymap(
  "n",
  "<leader>cpu",
  "<cmd>lua require('package-info').update()<cr>",
  { silent = true, noremap = true, desc = "Update package" }
)
set_keymap(
  "n",
  "<leader>cpi",
  "<cmd>lua require('package-info').install()<cr>",
  { silent = true, noremap = true, desc = "Install package" }
)
set_keymap(
  "n",
  "<leader>cpc",
  "<cmd>lua require('package-info').change_version()<cr>",
  { silent = true, noremap = true, desc = "Change package version" }
)
