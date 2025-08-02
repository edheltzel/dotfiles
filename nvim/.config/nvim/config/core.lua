local opt  = vim.opt
local fun = vim.fn
local cmd = vim.cmd

-- basic settings
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true
opt.scrolloff = 10                    -- keep 10 lines above/below the cursor
opt.sidescrolloff = 8                 -- keep 8 columns left/right of cursor

-- indents
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = false                 -- set to true if you want spaces instead of tabs
opt.smartindent = true
opt.autoindent = true

-- searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- file handling
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true                           -- persistent undo
opt.undodir = fun.expand('~/.vim/undodir')    -- undo directory 
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.autoread = true                           -- auto reload files if changed outside of neovim
opt.autowrite = false                         -- no autosaving

-- behavior
opt.hidden = true                             -- allow hidden buffers
opt.errorbells = false
opt.backspace = 'indent,eol,start'
opt.autochdir = false
opt.iskeyword:append('-')                     -- treat dash as apart of word
opt.path:append('**')
opt.selection = 'exclusive'
opt.mouse = 'a'
opt.clipboard:append('unnamedplus')
opt.modifiable = true
opt.encoding = 'UTF-8'

-- visual
opt.termguicolors = true
opt.signcolumn = 'yes'
opt.colorcolumn = '100' 
opt.showmatch = true
opt.matchtime = 1
opt.cmdheight = 1
opt.completeopt = 'menuone,noinsert,noselect'
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0
opt.conceallevel = 0
opt.concealcursor = ''
opt.lazyredraw = true
opt.synmaxcol = 300
opt.showmode = false
opt.guicursor = 'n-v-c:block-blinkon250-blinkoff250,i-ci-ve:ver25-blinkon250-blinkoff250'
cmd(":hi statusline guibg=NONE guifg=#0090d0")
