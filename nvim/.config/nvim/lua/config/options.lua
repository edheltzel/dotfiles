-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
--
local option = vim.opt
-- file handling  -------------------------------------------------------------------------------
option.backup = false -- dont create backup files
option.writebackup = false -- dont create backup files
option.swapfile = false -- dont create swap files
option.undofile = true -- Enable persistent undo, allows an undo history across sessions.
option.undodir = vim.fn.expand("~/.local/share/nvim/undodir") -- set undo directory

-- visual settings  -------------------------------------------------------------------------------
option.cursorcolumn = true
option.colorcolumn = "120" 

