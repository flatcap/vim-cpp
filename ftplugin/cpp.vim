" Only do this when not done yet for this buffer
" if exists("b:did_ftplugin")
" 	finish
" endif
" let b:did_ftplugin = 1

let g:rich_wip += 1
echohl error
echom printf ('seq %d, file %s', g:rich_wip, expand('<sfile>:p'))
echohl none

setlocal ts=4 sw=4 et

let maplocalleader = ';'

map <buffer> <LocalLeader><tab>  :echom 'hello'<CR>

" map <buffer> <LocalLeader>A  oanother line<Esc>

" imap \c =(exists ('b:class') ? b:class : '')<cr>

