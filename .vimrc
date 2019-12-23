set nocompatible              " be iMproved, required
filetype off                  " required

set hls
set shiftwidth=2 softtabstop=2 expandtab
set autoindent

set number relativenumber
au Filetype markdown source ~/.vim/ftplugin/markdown.vim
color herald


let mapleader = "-"
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  " alternatively, pass a path where Vundle should install plugins
  "call vundle#begin('~/some/path/here')

  Plugin 'VundleVim/Vundle.vim'

  Plugin 'sirver/ultisnips'

  Plugin 'godlygeek/tabular'
  Plugin 'plasticboy/vim-markdown'

  " Plugin 'cakebaker/scss-syntax.vim'
  " Plugin 'hail2u/vim-css3-syntax'
  Plugin 'beyondwords/vim-twig'

  Plugin 'rstacruz/sparkup'

  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  Plugin 'vim-syntastic/syntastic'
  Plugin 'prettier/vim-prettier'

  Plugin 'tpope/vim-fugitive'

call vundle#end()            " required
filetype plugin indent on    " required

" Put your non-Plugin stuff after this line
let g:airline_theme='sol'

" When working with Markdown files, grok the YAML frontmatter...
let g:vim_markdown_frontmatter = 1
" ...and don't fold
" let g:vim_markdown_folding_disabled = 1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
