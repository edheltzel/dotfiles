-- cspell: disable
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- KEY:
-- <M> = alt
-- <C> = ctrl
-- <leader> = space
-- <S> = shift

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

local set_keymap = vim.api.nvim_set_keymap

-- UNSET EXISTING KEYMAPS
keymap.del({ "n", "i", "v" }, "<A-j>")
keymap.del({ "n", "i", "v" }, "<A-k>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Right>")

-- General -------------------------------------------------------------------------------
-- Delete without yanking
keymap.set({ "n", "v" }, "<leader>d", "d", { desc = "Delete without yanking" })
-- ESCAPE INSERT MODE
keymap.set("i", "jj", "<Esc>", { desc = "Exit INSERT mode with jj" })
keymap.set("i", "jk", "<Esc>", { desc = "Exit INSERT mode with jk" })

keymap.set("n", "U", "<C-r>", { desc = "Redo" }) -- redo with U
keymap.set("n", "<D-z>", "u", { desc = "Redo" }) -- undo with cmd+z
-- JUMP to BOL/EOL
keymap.set("n", "gh", "^", { desc = "Jump beginning of line" })
keymap.set("n", "gl", "$", { desc = "Jump end of line" })
-- CLEAR SEARCH HIGHLIGHTS
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("v", "<", "<gv", { desc = "Indent left and reslect" })
keymap.set("v", ">", ">gv", { desc = "Indent right and reslect" })

-- Windows/Splits/Tabs -----------------------------------------------------------------------
-- SPLITS
keymap.set("n", "ss", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)
-- Resize
keymap.set("n", "<C-up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap.set("n", "<C-up>", ":vertical resize +2<CR>", { desc = "Increase window width" })
keymap.set("n", "<C-down>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
-- TABS
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<S-tab>", ":tabprev<Return>", opts)
-- WINDOWS
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move window left" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move window down" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move window up" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move window right" })

-- Plugins -----------------------------------------------------------------------------------
-- HARDTIME - enable/disable
keymap.set("n", "<leader>u0", ":Hardtime toggle<CR>", { desc = "Enable Hardtime" })

-- FLASH.NVIM KEYMAPS
keymap.set({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, { desc = "Flash" })
-- AUTO-SESSION KEYMAPS - adds to which-key
keymap.set("n", "<leader>qr", ":SessionRestore", { noremap = true, desc = "Restore Session" })
keymap.set("n", "<leader>qs", ":SessionSearch<ENTER>", { noremap = true, desc = "Search Sessions" })
keymap.set("n", "<leader>qS", ":SessionSave<ENTER>", { noremap = true, desc = "Save Session" })
keymap.set("n", "<leader>qd", ":SessionDelete", { noremap = true, desc = "Delete Session" })
keymap.set("n", "<leader>qx", ":SessionPurgeOrphaned", { noremap = true, desc = "Purge Orphan Session" })
--
-- BORDERLESS LAZYGIT
vim.keymap.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })

-- VSCODE Like -------------------------------------------------------------------------------
-- VSpaceCode-ish KEYMAPS
keymap.set("n", "<leader>fs", "<cmd>w<CR>", { noremap = true, desc = "Save file" })
keymap.set("n", "<ENTER>", "za", { desc = "Code Folding" })
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close active tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })

-- LAUNCH TERMINAL
vim.keymap.set({ "n", "t" }, "<C-`>", function()
  Util.terminal(nil, { border = "none" })
end, { desc = "Toggle terminal" })
-- LINE BUBBLING - Move lines up/down
keymap.set("n", "<A-down>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-up>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
-- j/k line bubbling
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

--
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
