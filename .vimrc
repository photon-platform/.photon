filetype off                  " required

set hls
set shiftwidth=2 softtabstop=2 expandtab
set autoindent
filetype plugin indent on    " required

set number relativenumber

set foldenable
set foldmethod=indent

" set showtabline=2
let g:airline#extensions#tabline#enabled = 1


hi CursorLine   cterm=NONE ctermbg=232
augroup CursorLine
   au!
   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
   au WinLeave * setlocal nocursorline
augroup END

hi Visual term=reverse cterm=reverse guibg=Grey

let mapleader = "\<Space>"
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>h :noh<cr>


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
  Plugin 'tpope/vim-surround'

  " Plugin 'ddevault/vimspeak'

  Plugin 'morhetz/gruvbox'
  " Plugin 'junegunn/goyo'
  " Plugin 'junegunn/limelight'

call vundle#end()            " required

set background=dark    " Setting dark mode
let g:gruvbox_contrast_dark = "hard"
color gruvbox

" Put your non-Plugin stuff after this line
let g:airline_theme='gruvbox'

" When working with Markdown files, grok the YAML frontmatter...
let g:vim_markdown_frontmatter = 1
" ...and don't fold
let g:vim_markdown_folding_disabled = 1

au Filetype markdown source ~/.vim/ftplugin/markdown.vim

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
