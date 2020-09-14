"     ____      _ __        _
"    /  _/___  (_) /__   __(_)___ ___
"    / // __ \/ / __/ | / / / __ `__ \
"  _/ // / / / / /__| |/ / / / / / / /
" /___/_/ /_/_/\__(_)___/_/_/ /_/ /_/
"
"
" Great stuff from https://www.chrisatmachine.com/neovim
" Repo is here https://github.com/ChristianChiarulli/nvim
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
  source $HOME/.config/nvim/configs/easymotion.vim
else
  " ordinary neovim
  source $HOME/.config/nvim/themes/syntax.vim
  source $HOME/.config/nvim/themes/onedark.vim
  source $HOME/.config/nvim/themes/airline.vim
  source $HOME/.config/nvim/configs/lf.vim
  source $HOME/.config/nvim/configs/fzf.vim
  source $HOME/.config/nvim/configs/nerd-commenter.vim
  source $HOME/.config/nvim/configs/rainbow.vim
  source $HOME/.config/nvim/configs/quickscope.vim
  source $HOME/.config/nvim/configs/vim-wiki.vim
  source $HOME/.config/nvim/configs/sneak.vim
  source $HOME/.config/nvim/configs/coc.vim
  source $HOME/.config/nvim/configs/goyo.vim
  source $HOME/.config/nvim/configs/vim-rooter.vim
  source $HOME/.config/nvim/configs/start-screen.vim
  source $HOME/.config/nvim/configs/gitgutter.vim
  source $HOME/.config/nvim/configs/closetags.vim
  source $HOME/.config/nvim/configs/floaterm.vim
  source $HOME/.config/nvim/configs/vista.vim
  luafile $HOME/.config/nvim/configs/colorizer.lua
  " source $HOME/.config/nvim/configs/easymotion.vim
endif

" Experimental

" Codi
let g:codi#rightalign=0
set shell=bash
