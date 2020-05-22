"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/
"
"
" most of this is from https://www.chrisatmachine.com/neovim
" Always source these
source $HOME/.config/nvim/plugs/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/which-key.vim
source $HOME/.config/nvim/general/paths.vim

" Source depending on if VSCode is our client
if exists('g:vscode')
    " VSCode extension
  source $HOME/.config/nvim/vscode/windows.vim
  source $HOME/.config/nvim/plugConfig/easymotion.vim
else
  " ordinary neovim
  source $HOME/.config/nvim/themes/syntax.vim
  source $HOME/.config/nvim/themes/onedark.vim
  source $HOME/.config/nvim/themes/airline.vim
  source $HOME/.config/nvim/plugConfig/rnvimr.vim
  source $HOME/.config/nvim/plugConfig/fzf.vim
  source $HOME/.config/nvim/plugConfig/nerd-commenter.vim
  source $HOME/.config/nvim/plugConfig/rainbow.vim
  source $HOME/.config/nvim/plugConfig/quickscope.vim
  source $HOME/.config/nvim/plugConfig/vim-wiki.vim
  source $HOME/.config/nvim/plugConfig/sneak.vim
  source $HOME/.config/nvim/plugConfig/coc.vim
  source $HOME/.config/nvim/plugConfig/goyo.vim
  source $HOME/.config/nvim/plugConfig/vim-rooter.vim
  source $HOME/.config/nvim/plugConfig/start-screen.vim
  source $HOME/.config/nvim/plugConfig/gitgutter.vim
  source $HOME/.config/nvim/plugConfig/closetags.vim
  source $HOME/.config/nvim/plugConfig/floaterm.vim
  source $HOME/.config/nvim/plugConfig/vista.vim
  luafile $HOME/.config/nvim/lua/plug-colorizer.lua
  " source $HOME/.config/nvim/plugConfig/easymotion.vim
endif

" Experimental

" Codi
let g:codi#rightalign=0

