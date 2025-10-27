-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- KEY:
-- <M> = alt
-- <C> = ctrl
-- <leader> = space
-- <S> = shift
-- <CR> = carriage return

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

local set_keymap = vim.api.nvim_set_keymap

-- UNSET EXISTING KEYMAPS
-- keymap.del({ "n", "i", "v" }, "<A-j>")
-- keymap.del({ "n", "i", "v" }, "<A-k>")
-- keymap.del("n", "<C-Left>")
-- keymap.del("n", "<C-Down>")
-- keymap.del("n", "<C-Up>")
-- keymap.del("n", "<C-Rightl")

-- General -------------------------------------------------------------------------------
-- Delete without yanking
keymap.set({ "n", "v" }, "<leader>d", "d", { desc = "Delete without yanking" })
--
keymap.set("i", "jk", "<Esc>", { desc = "Exit INSERT mode with jk" }) -- ESCAPE INSERT MODE
keymap.set("t", "<Esc>", "<C-\\><C-n>") -- ESCAPE TERMINAL MODE
--
keymap.set("n", "U", "<C-r>", { desc = "Redo" }) -- redo with U
--
-- JUMP to BOL/EOL
keymap.set("n", "gh", "^", { desc = "Jump beginning of line" })
keymap.set("n", "gl", "$", { desc = "Jump end of line" })
--
-- CLEAR SEARCH HIGHLIGHTS
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("v", "<", "<gv", { desc = "Indent left and reslect" }) -- shift+,
keymap.set("v", ">", ">gv", { desc = "Indent right and reslect" }) -- shift+.
--
-- LINE BUBBLING - Move lines up/down
---- move line down
keymap.set("n", "<A-down>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
---- move line up
keymap.set("n", "<A-up>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- VSpaceCode-ish -------------------------------------------------------------------------------
---- save file
keymap.set("n", "<leader>fs", ":w<CR>", {})
---
---- flash
keymap.set({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, { desc = "Jump to character" })
---
---- code folding
keymap.set("n", "<ENTER>", "za", { desc = "Code Folding" })
---- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close active tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
---- terminal
keymap.set({ "n", "t" }, "<C-`>", function()
  Util.terminal(nil, { border = "none" })
end, { desc = "Toggle terminal" })
-- Move around splits
keymap.set("n", "<leader>wj", "<C-w>j", { desc = "switch window right" })
keymap.set("n", "<leader>wk", "<C-w>k", { desc = "switch window up" })
keymap.set("n", "<leader>wl", "<C-w>l", { desc = "switch window down" })

---- with Ctrl
keymap.set("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "switch window right" })

-- BORDERLESS LAZYGIT
keymap.set("n", "<leader>gg", function()
  Snacks.lazygit({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })
