-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save file
vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>", { noremap = true, desc = "Save window" })
