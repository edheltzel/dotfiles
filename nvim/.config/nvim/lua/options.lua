local o = vim.o

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line numbers
o.relativenumber = true
o.number = true

o.laststatus = 3 -- global statusline
o.showmode = false

o.clipboard = "unnamedplus"
o.shell = "/bin/bash"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2
o.breakindent = true
o.breakindentopt = "sbr"
o.showbreak = "↪"

vim.opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

o.number = true

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.timeoutlen = 400
o.undofile = true
o.cursorline = true

o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

o.scrolloff = 10
vim.diagnostic.config({
	virtual_text = false,
})
-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath("data") .. "/mason/bin"

vim.api.nvim_set_hl(0, "IndentLine", { link = "Comment" })
