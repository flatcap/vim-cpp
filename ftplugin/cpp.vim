if (exists ("b:did_ftplugin"))
	finish
endif
let b:did_ftplugin = 1

let g:c_space_errors=1

" Enable folding.
setlocal foldmethod=expr
setlocal foldexpr=cpp_fold#FoldLevel(v:lnum)
setlocal foldtext=cpp_fold#FoldText(v:foldstart)
setlocal foldcolumn=0
setlocal foldclose=
setlocal foldopen=
" setlocal foldopen+=mark
setlocal foldopen+=tag
setlocal foldopen+=quickfix
"setlocal foldopen+=search

" " More preferences
" let s:path = expand ("%:p")
" if ((s:path =~ '/upstream/') || (s:path =~ '^/usr/include/'))
" 	setlocal foldlevel=4
" 	setlocal conceallevel=0
" else
" 	let s:suffix = expand ('%:e')
" 	if ((s:suffix == 'h') || (s:suffix == 'hpp'))
" 		setlocal foldlevel=1
" 		setlocal conceallevel=0
" 	else
" 		setlocal foldlevel=0
" 		setlocal conceallevel=2
" 	endif
" endif

" augroup RichCpp
" 	autocmd!
" 	" If there's an error in my STL use, there's little point staring at the source
" 	autocmd BufRead /usr/include/c++/4.9.2/*  setlocal filetype=cpp syntax=cpp bufhidden=delete
" 	autocmd BufRead /usr/include/sigc++-2.0/* setlocal filetype=cpp syntax=cpp bufhidden=delete
" augroup END

" let b:class = cpp#GetClassName()

" inoremap <silent> <buffer> \c =(exists ('b:class') ? b:class : '')<cr>
" \f for filename
" \x for exchanged cpp <-> h
" \b for base class (HOW?)
" what else?
" can't clash with real escapes \e \n \t

let maplocalleader = '\'

" nmap <silent> <buffer> <LocalLeader>fc :<c-u>silent! call cpp#AddCommentBlock()<CR>
" nmap <silent> <buffer> <LocalLeader>ff :<c-u>silent! source ~/.vim/fold/c.vim<CR>

nmap <silent> <buffer> <LocalLeader>m :<c-u>call cpp#RichMake()<CR>

" nmap <silent> <buffer> <F2>      :<c-u>wall<CR>:make .obj/%:r.o<CR>
" nmap          <buffer> <F4>      :<c-u>call cpp#RotateTags()<CR>
" nmap <silent> <buffer> <F10>     :<c-u>cnext<CR>zvzz
" nmap <silent> <buffer> <F11>     :<c-u>cc<CR>zvzz
" nmap <silent> <buffer> <F12>     :<c-u>cwindow 5<CR>

" #ifdef 0
vmap <silent> <buffer> <LocalLeader>0 :call cpp#Ifdef()<CR>
vmap <silent> <buffer> <LocalLeader>r :call cpp#Ifdef('RAR')<CR>

" nmap <silent> <buffer> gcr :setlocal commentstring=//RAR%s<cr><Plug>CommentaryLine:setlocal commentstring=//%s<CR>

" open tag in new window
nnoremap <silent> <buffer> <C-W>]     :<c-u>vsplit<CR><C-]>zv
nnoremap <silent> <buffer> <C-W><C-]> :<c-u>vsplit<CR><C-]>zv

set fdl=1
" set fdm=manual
