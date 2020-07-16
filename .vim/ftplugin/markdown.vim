set wrap
set linebreak
set foldmethod=manual
nnoremap <leader>yc ggjV/---/<cr>kzf<cr>j:noh<cr>
nnoremap <leader>yo ggjzo
nnoremap <leader>yt gg/title:/<cr>:noh<cr>2w
nnoremap <leader>k k0/[:-]/<cr>:noh<cr>
nnoremap <leader>j j0/[:-]/<cr>:noh<cr>

set spell
hi clear SpellBad
hi SpellBad ctermfg=red cterm=underline

function Clean()
  %s/<a href="\/elem.\(.\{-}\)">.\{-}<\/a>/\1/cg<cr>
  %s/<.b n="\d*"\/>//g<cr>
endfunction

