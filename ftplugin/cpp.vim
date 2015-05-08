" Enable folding.
setlocal foldmethod=expr
setlocal foldexpr=cpp_fold#FoldLevel(v:lnum)
setlocal foldtext=cpp_fold#FoldText(v:foldstart)
setlocal foldcolumn=0
setlocal foldclose=
setlocal foldopen=
setlocal foldopen+=mark
setlocal foldopen+=tag
setlocal foldopen+=quickfix
"setlocal foldopen+=search

let b:class = cpp#GetClassName()

inoremap <silent> <buffer> \c =(exists ('b:class') ? b:class : '')<cr>

" More preferences
let s:path = expand("%:p")
if (s:path =~ '/upstream/')
	setlocal foldlevel=4
	setlocal conceallevel=0
else
	let s:suffix = expand ('%:e')
	if ((s:suffix == 'h') || (s:suffix == 'hpp'))
		setlocal foldlevel=1
		setlocal conceallevel=0
	else
		setlocal foldlevel=0
		setlocal conceallevel=2
	endif
endif

finish

" Only do this when not done yet for this buffer
" if exists("b:did_ftplugin")
" 	finish
" endif
" let b:did_ftplugin = 1

let maplocalleader = ';'

" map <buffer> <LocalLeader>A  oanother line<Esc>

" imap \c =(exists ('b:class') ? b:class : '')<cr>

" \f for filename
" \x for exchanged cpp <-> h
" \b for base class (HOW?)

" what else?
" can't clash with real escapes \e \n \t

autocmd BufNewFile,BufRead *.c,*.h,*.cc,*.cpp source ~/.vim/fold/c.vim

" If there's an error in my STL use, there's little point staring at the source
autocmd BufRead /usr/include/*            setlocal foldlevel=4
autocmd BufRead /usr/include/c++/4.9.2/*  setlocal syntax=c bufhidden=delete
autocmd BufRead /usr/include/sigc++-2.0/* setlocal syntax=c bufhidden=delete

nmap <silent> <LocalLeader>fc :silent! call cpp#AddCommentBlock()<CR>
nmap <silent> <LocalLeader>ff :silent! source ~/.vim/fold/c.vim<CR>

nmap <silent> <LocalLeader>m :call cpp#RichMake()<CR>

nmap <silent> <F2>      :wall<CR>:make .obj/%:r.o<CR>
nmap          <F4>      :call cpp#RotateTags()<CR>
nmap <silent> <F10>     :cnext<CR>zvzz
nmap <silent> <F11>     :cc<CR>zvzz
nmap <silent> <F12>     :cwindow 5<CR>

" open tag in new window
nnoremap <C-W>] :vsplit<CR><C-]>zv

let g:c_space_errors=1

" #ifdef 0
vmap <LocalLeader>0 :call cpp#Ifdef()<CR>
vmap <LocalLeader>r :call cpp#Ifdef('RAR')<CR>

nmap <silent> gcr :setlocal commentstring=//RAR%s<cr><Plug>CommentaryLine:setlocal commentstring=//%s<CR>

