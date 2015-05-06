finish

let g:rich_wip += 1
echohl error
echom printf ('seq %d, file %s', g:rich_wip, expand('<sfile>:p'))
echohl none

autocmd BufNewFile,BufRead *.c,*.h,*.cc,*.cpp source ~/.vim/fold/c.vim

if ((hostname() == 'laptop.flatcap.org') && (expand('$USER') == 'flatcap'))
	autocmd BufEnter *.cpp,*.h call classname#classname()
	autocmd BufNewFile,BufRead * call LoadVimLocal()
endif

" If there's an error in my STL use, there's little point staring at the source
autocmd BufRead /usr/include/* set foldlevel=4
autocmd BufRead /usr/include/c++/4.9.2/*  set syntax=c bufhidden=delete
autocmd BufRead /usr/include/sigc++-2.0/* set syntax=c bufhidden=delete

nmap <silent> <leader>fc :silent! call function#CommentBlock()<CR>
nmap <silent> <leader>ff :silent! source ~/.vim/fold/c.vim<CR>

nmap <silent> <leader>m :call make#RichMake()<CR>

nmap <silent> <F2>      :wall<CR>:make .obj/%:r.o<CR>
nmap          <F4>      :call tagsrotate#TagsRotate()<CR>
nmap <silent> <F10>     :cnext<CR>zvzz
nmap <silent> <F11>     :cc<CR>zvzz
nmap <silent> <F12>     :cwindow 5<CR>

" open tag in new window
nnoremap <C-W>] :vsplit<CR><C-]>zv

let g:c_space_errors=1

" #ifdef 0
vmap <leader>0 :call ifzero#Ifdef()<CR>
vmap <leader>r :call ifzero#Ifdef('RAR')<CR>

nmap <silent> gcr :set commentstring=//RAR%s<cr><Plug>CommentaryLine:set commentstring=//%s<CR>

" More preferences
let path = expand("%:p")
if (path =~ '/upstream/')
	set foldlevel=4
	set conceallevel=0
else
	if (expand ("%:e") == 'h')
		set foldlevel=1
		set conceallevel=0
	else
		set foldlevel=0
		set conceallevel=2
	endif
endif

