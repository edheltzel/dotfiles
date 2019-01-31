" DESCRIPTION: THIS IS A PERSONAL VIM CONFIGURATION. ATTEMPTS HAVE BE MADE TO DOCUMENT
" EACH COMMAND. IT IS BEST TO TRY TO UNDERSTAND WHAT EACH COMMAND DOES INSTEAD OF BINDLY
" USING IT.
"
" REMEMBER, THIS VIM CONFIG IS TO SUIT MY NEEDS WHICH MAY NOT BE COMPATIBLE
" WITH YOURS.SO FEEL FREE TO PICK OUT THE BITS YOU LIKE AND TOSS THE REST ASIDE

" Disallow detection of filetypes
filetype off

" #PLUGINS {%
call plug#begin('~/.local/share/nvim/plugged')
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
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'airblade/vim-gitgutter'
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-fugitive' " Awesome git wrapper
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

let g:vim_markdown_folding_disabled = 1
let mapleader = ","

filetype plugin indent on    " required
runtime macros/matchit.vim

" SUPERTAB {%
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
let g:SuperTabClosePreviewOnPopupClose = 1
" %}

syntax enable

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif

set background=dark
let g:one_allow_italics = 1
colorscheme one
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum

" #DEOPLETE (AND FRIENDS) {%
if has('nvim')
  " Enable deoplete on startup
  let g:deoplete#enable_at_startup = 1
endif
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
set completeopt=longest,menuone,preview
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
" %}

" #TERN {%
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
" %}

" #CTRLP SETTINGS {%
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_user_command = {
\	'types': {
\		1: ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'],
\	},
\	'ignore': 1,
\}

nnoremap <Leader>b :CtrlPBuffer<CR>
"%}


" #EMMET SETTINGS {%
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}
"%}

" #MARKDOWN {%
let g:pencil#textwidth = 80

au BufNewFile,BufRead,BufWrite *.md syntax match Comment /\%^---\_.\{-}---$/
let g:markdown_fenced_languages = ['rust', 'css', 'yaml', 'javascript', 'html', 'vim','json']

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,md call pencil#init({'wrap': 'soft'})
augroup END
"%}

" #TEMPLATES {%
" Prefill new files created by vim with contents from the following templates
augroup templates
  autocmd BufNewFile *.html 0r ~/.config/nvim/templates/skeleton.html
  autocmd BufNewFile *.scss 0r ~/.config/nvim/templates/skeleton.scss
  autocmd BufNewFile *.css 0r ~/.config/nvim/templates/skeleton.scss
  autocmd BufNewFile *.rs 0r ~/.config/nvim/templates/skeleton.rs
  autocmd BufNewFile LICENCE 0r ~/.config/nvim/templates/skeleton.LICENCE
  autocmd BufNewFile LICENSE 0r ~/.config/nvim/templates/skeleton.LICENCE
  autocmd BufNewFile .gitignore 0r ~/.config/nvim/templates/skeleton.gitignore
augroup END
"%}

"" Disable F1 bringing up the help doc every time
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

"" A saner way to save files.<F2> is easy to press
nnoremap <F2> :w<CR>

" #ALE SETTINGS {%
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['json'] = ['prettier']
let g:ale_fixers['scss'] = ['stylelint', 'prettier']
let g:ale_javascript_prettier_use_local_config = 1 " respect prettier local files
let g:ale_fix_on_save = 1 " Fix files automatically on save
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>
nnoremap <F6> :ALEFix<CR>
"%}

" #AIRLINE SETTINGS {%
let g:airline_powerline_fonts = 1
let g:airline_theme='onedark'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#ale#enabled = 1 " Integrate Airline with ALE
"%}

" Stop concealing quotes in JSON
let g:vim_json_syntax_conceal = 0

" Enable JSX syntax highlighting in .js files
let g:jsx_ext_required = 0


:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" #MOVING LINES
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Show leader key
set showcmd

" #TABS AND SPACES {%
set expandtab " On pressing tab, insert 2 spaces
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=2
set shiftwidth=2 " when indenting with '>', use 2 spaces width
"%}

set number " Show line numbers
set noswapfile " No swap file
set nobackup
set nowritebackup

set textwidth=80
set formatoptions+=t
set colorcolumn=+1
set showmatch
set lazyredraw

" #FINDING FILES
" Use the `:find` command to fuzzy search files in the working directory
" The `:b` command can also be used to do the same for open buffers

" Search all subfolders
set path+=**

" Display matching files on tab complete
set wildmenu

" Ignore node_modules and images from search results and from CtrlP
set wildignore+=**/node_modules/**,**/dist/**,**_site/**,*.swp,*.png,*.jpg,*.gif,*.webp,*.jpeg,*.map

" Use the system register for all cut yank and paste operations
set clipboard=unnamedplus

" Toggle Hybrid Numbers in insert and normal mode
:set number relativenumber

" Show Invisibles
set list
set listchars=tab:→→,eol:¬,space:.

" Automatically hide buffer with unsaved changes without showing warning
set hidden

" Treat all numbers as decimal regardless of whether they are padded with zeros
set nrformats=

" Highlight matches when using :substitute
set hlsearch

" Predicts case sensitivity intentions
set smartcase

" Jump to match when searching
set incsearch

hi NonText guifg=#4a4a59
hi SpecialKey guifg=white guibg=#cc0000

" Strip trailing whitespace from all files
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\s\+$//e

" #UltilSnips Configuration {%
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetsDir="~/.config/nvim/snips"
let g:UltiSnipsSnippetDirectories=["UtilSnips", "snips"]
"%}

" #NETRW settings {%
" Set preferred view
let g:netrw_liststyle = 3
" Remove banner
let g:netrw_banner = 0
" %}

" Prevent the use of arrow keys for navigation
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Shortcut to open init.vim
nnoremap <leader>ev :vsp $MYVIMRC<CR>

" Save state of open Windows and Buffers
nnoremap <leader>s :mksession<CR>

" Bbye
nnoremap <leader>q :Bwipeout<CR>


" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

au BufRead,BufNewFile,BufReadPost *.json set syntax=json

" # Taboo Config {%
nnoremap <leader>t :TabooRename
nnoremap <leader>o :TabooOpen
" %}
" # Ruby Stuff {%
let g:ruby_host_prog = '~/.rbenv/shims/ruby'
" %}

" # Rust Stuff {%
let g:racer_cmd = "/home/ed/.cargo/bin/racer"
" %}

