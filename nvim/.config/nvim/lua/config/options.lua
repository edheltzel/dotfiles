-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
--
-- file handling  -------------------------------------------------------------------------------
vim.opt.backup = false -- dont create backup files
vim.opt.writebackup = false -- dont create backup files
vim.opt.swapfile = false -- dont create swap files

-- Enable persistent undo, allows an undo history across sessions.
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.local/share/nvim/undodir") -- set undo directory

-- visual settings  -------------------------------------------------------------------------------
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "100"
