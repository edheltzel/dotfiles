-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- KEY:
-- <M> = alt
-- <C> = ctrl
-- <leader> = space
-- <S> = shift
-- <CR> = carriage return

local set = vim.keymap.set
-- local del = vim.keymap.del
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

local set_keymap = vim.api.nvim_set_keymap

-- UNSET EXISTING KEYMAPS
-- del({ "n", "i", "v" }, "<A-j>")
-- del({ "n", "i", "v" }, "<A-k>")
-- del("n", "<C-Left>")
-- del("n", "<C-Down>")
-- del("n", "<C-Up>")
-- del("n", "<C-Right")

-- General -------------------------------------------------------------------------------
-- Delete without yanking
set({ "n", "v" }, "<leader>d", "d", { desc = "Delete without yanking" })
-- delete word by alt+backspace macos style
set({ "i", "c" }, "<A-BD>", "<C-w>", { noremap = true })
set("n", "<A-BS>", "db", { noremap = true })
-- redo with shift+u (U)
set("n", "U", "<C-r>", { desc = "Redo" })
set("n", "<C-a>", "ggVG", { desc = "Select all" })

---- Multiword/Cursors
set({ "n" }, "<C-n>", "*Ncgn", { desc = "MultiWord editing use . to repeat" })

set("i", "jk", "<Esc>", { desc = "Exit INSERT mode with jk" }) -- ESCAPE INSERT MODE
set("i", "jj", "<Esc>", { desc = "Exit INSERT mode with jj" }) -- ESCAPE INSERT MODE
set("t", "<Esc>", "<C-\\><C-n>") -- ESCAPE TERMINAL MODE

set("v", "<D-C-Up>", "y`>p`<", { silent = true })
set("n", "<D-C-Up>", "Vy`>p`<", { silent = true })
set("v", "<D-C-Down>", "y`<kp`>", { silent = true })
set("n", "<D-C-Down>", "Vy`<p`>", { silent = true })

-- JUMP to BOL/EOL
set("n", "gh", "^", { desc = "Jump beginning of line" })
set("n", "gl", "$", { desc = "Jump end of line" })

-- CLEAR SEARCH HIGHLIGHTS
set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
set("v", ">", ">gv", { desc = "Indent right and reselect" }) -- shift+.
set("v", "<", "<gv", { desc = "Indent left and reselect" }) -- shift+,

-- LINE BUBBLING - Move lines up/down
---- move line down
set("n", "<A-down>", ":m .+1<CR>==", { desc = "Move line down" })
set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
set("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
---- move line up
set("n", "<A-up>", ":m .-2<CR>==", { desc = "Move line up" })
set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
set("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- VSpaceCode-ish -------------------------------------------------------------------------------
---- save file
set("n", "<leader>fs", ":w<CR>", {})
---
---- flash
set({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, { desc = "Jump to character" })
---
---- code folding
set("n", "<ENTER>", "za", { desc = "Code Folding" })
---- tabs
set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close active tab" })
set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
---- terminal
set({ "n", "t" }, "<C-`>", function()
  Util.terminal(nil, { border = "none" })
end, { desc = "Toggle terminal" })
-- Move around splits
set("n", "<leader>wj", "<C-w>j", { desc = "switch window right" })
set("n", "<leader>wk", "<C-w>k", { desc = "switch window up" })
set("n", "<leader>wl", "<C-w>l", { desc = "switch window down" })

---- with Ctrl
set("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
set("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
set("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
set("n", "<C-l>", "<C-w>l", { desc = "switch window right" })

-- BORDERLESS LAZYGIT
set("n", "<leader>gg", function()
  Snacks.lazygit({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })
