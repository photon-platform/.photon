set wrap
set linebreak
set foldmethod=manual

set tabstop=4
set shiftwidth=4
set expandtab

nnoremap <leader>yc ggjV/---/<cr>kzf<cr>j:noh<cr>
nnoremap <leader>yo ggjzo
nnoremap <leader>yt gg/title:/<cr>:noh<cr>2w
nnoremap <leader>k k0/[:-]/<cr>:noh<cr>
nnoremap <leader>j j0/[:-]/<cr>:noh<cr>
nnoremap <leader>= gg/---/<cr>:noh<cr>j

nnoremap <leader>0 0:s/[#]*\s*//<cr>:noh<cr>
nnoremap <leader>1 0:s/[#]*\s*/# /<cr>:noh<cr>
nnoremap <leader>2 0:s/[#]*\s*/## /<cr>:noh<cr>
nnoremap <leader>3 0:s/[#]*\s*/### /<cr>:noh<cr>
nnoremap <leader>4 0:s/[#]*\s*/#### /<cr>:noh<cr>
nnoremap <leader>5 0:s/[#]*\s*/##### /<cr>:noh<cr>
nnoremap <leader>6 0:s/[#]*\s*/###### /<cr>:noh<cr>

set spell
hi clear SpellBad
hi SpellBad ctermfg=red cterm=underline

" function for cleaning content for the euclid project
function Clean()
  %s/<a href="\/elem.\(.\{-}\)">.\{-}<\/a>/\1/cg<cr>
  %s/<.b n="\d*"\/>//g<cr>
endfunction

