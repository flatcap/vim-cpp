finish

" Only do this when not done yet for this buffer
" if exists("b:did_ftplugin")
" 	finish
" endif
" let b:did_ftplugin = 1

echohl error
echom printf ('file %s', expand('<sfile>:p'))
echohl none

setlocal ts=4 sw=4 et

let maplocalleader = ';'

map <buffer> <LocalLeader><tab>  :echom 'hello'<CR>

" map <buffer> <LocalLeader>A  oanother line<Esc>

" imap \c =(exists ('b:class') ? b:class : '')<cr>

" Enable folding.
setlocal foldexpr=C_FoldLevel(v:lnum)
setlocal foldtext=C_FoldText(v:foldstart)

