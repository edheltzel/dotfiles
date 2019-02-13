" https://github.com/afnanenayet/nvim-dotfiles/blob/master/config/01.plugins.vim
" Required:

" #PLUGINS {%
call plug#begin('~/.config/nvim/plugged')
Plug 'cespare/vim-toml'
Plug 'moll/vim-bbye'
Plug 'mattn/emmet-vim'
Plug 'elzr/vim-json'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'plasticboy/vim-markdown'
Plug 'nelstrom/vim-markdown-folding'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'fatih/vim-go'
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'airblade/vim-gitgutter'
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-liquid'
Plug 'parkr/vim-jekyll'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-fugitive' " Awesome git wrapper
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'SirVer/ultisnips'
Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'digitaltoad/vim-pug' "Syntax highlighting for Pug
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'gcmt/taboo.vim'
Plug 'ervandew/supertab'
call plug#end()
"%}
