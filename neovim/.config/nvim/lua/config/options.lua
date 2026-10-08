-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g
local o = vim.o
o.timeoutlen = 250

g.loaded_python3_provider = 0

opt.cursorline = true
opt.scrolloff = 8

opt.linespace = 2
opt.textwidth = 100
opt.colorcolumn = "100"
opt.wrap = true

opt.swapfile = false
opt.backup = false

opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"

opt.spell = false
opt.spelllang = "en_us"

g.lazygit_config = false
