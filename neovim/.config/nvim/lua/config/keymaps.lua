-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
local set = vim.keymap.set
local del = vim.keymap.del
local wk = require("which-key")
local Snacks = require("snacks")

-- unset
del({ "n", "i", "v" }, "<A-k>")
del({ "n", "i", "v" }, "<A-j>")

-- UI -------------------------------------------------
set("n", "<leader>nh", ":nohl<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- JK to exit insert mode
api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false, desc = "exit INSERT mode" })

-- delete without yanking
set({ "n", "v" }, "<leader>d", '"_d', { noremap = true, silent = true, desc = "Delete without yanking" })

-- jump to beginning/end of line
set("n", "gh", "^", { noremap = true, silent = true, desc = "Jump beginning of line" })
set("n", "gl", "$", { noremap = true, silent = true, desc = "Jump end of line" })

-- alt-backspace
set({ "i", "c" }, "<A-BD>", "<C-w>", { noremap = true, desc = "Delete word w/ alt-backspace" })
set("n", "<A-BS>", "db", { noremap = true, desc = "Delete word w/ alt-backspace" })

set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo w/ U" })
-- set("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Escape terminal" })

-- duplicate lines up/down
set({ "n", "v" }, "<A-S-d>", "Vy`<p`>", { noremap = true, silent = true, desc = "Duplicate line down" })

set({ "n", "v" }, "<A-S-d>", "Vy`<p`>", { noremap = true, silent = true, desc = "Duplicate line down" })
-- set({ "n", "v" }, "<A-S-k>", "Vy`<p`>", { noremap = true, silent = true, desc = "Duplicate line down" })

-- indent line
set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })
set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })

-- move line down
set({ "n", "v" }, "<A-down>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
set({ "n", "v" }, "<A-S-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })

-- move line up
set({ "n", "v" }, "<A-up>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
set({ "n", "v" }, "<A-S-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })

-- toggle terminal
set({ "n", "t" }, "<C-`>", function()
  Snacks.terminal(nil, { border = "none" })
end, { noremap = true, silent = true, desc = "Toggle terminal" })

---- move around splits
set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "switch window left" })
set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "switch window down" })
set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "switch window up" })
set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "switch window right" })
set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "switch window left" })
set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "switch window down" })
set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "switch window up" })
set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "switch window right" })

-- set("n", "<ENTER>", "za", { noremap = true, silent = true, desc = "Code Folding" })
-- indenting
set("n", "<C-]>", ">>", { noremap = true, silent = true, desc = "Indent right" })
set("n", "<C-[>", "<<", { noremap = true, silent = true, desc = "Indent left" })
set("v", "<C-]>", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })
set("v", "<C-[>", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
-- shift+.
set("n", ">", ">>", { noremap = true, silent = true, desc = "Indent right" })
set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })
-- shift+,
set("n", "<", "<<", { noremap = true, silent = true, desc = "Indent left" })
set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
-- jump to character like vspacecode
set({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, { noremap = true, silent = true, desc = "Jump to character" })
-- save like vspacecode
set("n", "<leader>fs", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
set("n", "<leader>fS", ":noautocmd w<CR>", { noremap = true, silent = true, desc = "Save without formatting" })
set("n", "<leader>sf", ":%s#", { desc = "Search/Replace Buffer(:%s#old/path#new/path#g)" })

-- Spelling ----------------------------------------
wk.add({ { "<leader>S", group = "Spelling", icon = { icon = "󰓆", color = "green" } } })
set("n", "<leader>Ss", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  vim.notify(vim.opt_local.spell:get() and "Spell check ON" or "Spell check OFF")
end, { desc = "Toggle spell (buffer)" })
set("n", "<leader>Sa", "zg", { remap = true, desc = "Add word to dictionary" })
set("n", "<leader>Sw", "zw", { remap = true, desc = "Mark word as wrong" })
set("n", "<leader>Su", "zug", { remap = true, desc = "Undo add word" })
set("n", "<leader>S=", "z=", { remap = true, desc = "Spelling suggestions" })
set("n", "<leader>Sn", "]s", { remap = true, desc = "Next misspelled" })
set("n", "<leader>Sp", "[s", { remap = true, desc = "Prev misspelled" })
set("n", "<leader>Sf", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/spell/en.utf-8.add")
end, { desc = "Edit spellfile" })

-- toggle inlay hints
wk.add({ { "<leader>i", group = "Inlay Hints", icon = { icon = "ℹ", color = "orange" } } })
set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
end, { desc = "Toggle inlay hints" })

-- Move LazyVim changelog from <leader>L to <leader>l
set("n", "<leader>lc", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })
del("n", "<leader>L")

-- borderless lazygit
set("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = vim.fn.getcwd(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { noremap = true, silent = true, desc = "Lazygit (root dir)" })

-- GitButler TUI
set("n", "<leader>gb", function()
  Snacks.terminal({ "but", "tui" }, { cwd = vim.fn.getcwd(), win = { border = "rounded" } })
end, { noremap = true, silent = true, desc = "GitButler TUI" })

-- GitHub Dash
set("n", "<leader>gh", function()
  Snacks.terminal({ "gh", "dash" }, { cwd = vim.fn.getcwd(), win = { border = "rounded" } })
end, { noremap = true, silent = true, desc = "GitHub Dash" })

--------------------------------------------------------------------------------------------
---- MacOS CMD keymaps ---------------------------------------------------------------------
---- CSI u keyboard protocol must be supported by your terminal ----------------------------
--------------------------------------------------------------------------------------------
set("n", "<D-c>", '"+yiw', { noremap = true, silent = true, desc = "Copy word" })
set("v", "<D-c>", '"+y', { noremap = true, silent = true, desc = "Copy selection" })
set("n", "<D-v>", '"+p', { noremap = true, silent = true, desc = "Paste" })
set("v", "<D-v>", '"+p', { noremap = true, silent = true, desc = "Paste" })
set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste in insert mode" })
set("n", "<D-x>", '"+diw', { noremap = true, silent = true, desc = "Cut word" })
set("v", "<D-x>", '"+d', { noremap = true, silent = true, desc = "Cut selection" })
set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
set("n", "<D-z>", "u", { noremap = true, silent = true, desc = "Undo" })
set("i", "<D-z>", "<C-o>u", { noremap = true, silent = true, desc = "Undo in insert mode" })
set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
set("i", "<D-S-z>", "<C-o><C-r>", { noremap = true, silent = true, desc = "Redo in insert mode" })
set("n", "<D-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })
