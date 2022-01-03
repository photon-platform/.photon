filetype off                  " required

set shiftwidth=2 softtabstop=2 expandtab
set autoindent
filetype plugin indent on    " required

set number relativenumber

set ignorecase
set smartcase
set incsearch
set hls

set wildmenu

set foldenable
set foldmethod=indent
set foldlevel=99

" set showtabline=2
let g:airline#extensions#tabline#enabled = 1


hi CursorLine   cterm=NONE ctermbg=232
augroup CursorLine
   au!
   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
   au VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
   au WinLeave * setlocal nocursorline
augroup END


hi Visual term=reverse cterm=reverse guibg=Grey

let mapleader = "\<Space>"
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>h :noh<cr>
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>F :GFiles<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>B :BTags<cr>
nnoremap <leader>T :Tags<cr>
nnoremap <leader>S :Snippets<cr>
nnoremap <leader>C :Commands<cr>
nnoremap <leader>m :Marks<cr>
nnoremap <leader>M :Maps<cr>
nnoremap <leader>Y :Commits<cr>
nnoremap <leader>H :Helptags<cr>
nnoremap <leader>L :Lines<cr>
nnoremap <leader>W :Windows<cr>
nnoremap <leader>w :%s/\s\+$//e<cr>

nnoremap <leader>ue :UltiSnipsEdit<cr>

" Primeagen remaps
nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  " alternatively, pass a path where Vundle should install plugins
  "call vundle#begin('~/some/path/here')

  Plugin 'VundleVim/Vundle.vim'

  " Plugin 'tpope/vim-fugitive'
  " Plugin 'airblade/vim-gitgutter'

  " Plugin 'ludovicchabant/vim-gutentags'

  " Plugin 'sirver/ultisnips'

  " Plugin 'godlygeek/tabular'
  
  Plugin 'mattn/emmet-vim'

  Plugin 'plasticboy/vim-markdown'

  Plugin 'cakebaker/scss-syntax.vim'

  Plugin 'lumiliet/vim-twig'

  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  Plugin 'vim-syntastic/syntastic'
  Plugin 'prettier/vim-prettier'

  Plugin 'tpope/vim-surround'
  Plugin 'preservim/nerdcommenter'

  " Plugin 'ddevault/vimspeak'

  " Plugin 'morhetz/gruvbox'
  Plugin 'junegunn/fzf'
  Plugin 'junegunn/fzf.vim'

  " Plugin 'jasonshell/vim-svg-indent'
  Plugin 'chrisbra/unicode.vim'

  " Plugin 'GutenYe/json5.vim'
  " Plugin 'ycm-core/YouCompleteMe'


call vundle#end()            " required

set background=dark    " Setting dark mode
" let g:gruvbox_contrast_dark = "hard"
" color pablo

" Put your non-Plugin stuff after this line
" let g:airline_theme='gruvbox'

" When working with Markdown files, grok the YAML frontmatter...
let g:vim_markdown_frontmatter = 1
" ...and don't fold
let g:vim_markdown_folding_disabled = 1

au Filetype markdown source ~/.vim/ftplugin/markdown.vim

autocmd FileType scss set iskeyword+=-

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:NERDSpaceDelims = 1

imap <F5> <Esc>:w<CR>:!clear;python %<CR>
map <F5> <Esc>:w<CR>:!clear;python %<CR>

hi Normal guibg=NONE ctermbg=NONE
