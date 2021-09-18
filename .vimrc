filetype indent on
set incsearch
set number
set relativenumber
set paste
set tabstop=4
set shiftwidth=4
syntax on

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'skanehira/docker-compose.vim'
Plug 'junegunn/fzf'
