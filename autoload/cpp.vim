" cpp.vim - Autoload scripts for c/cpp
" Author:       Rich Russon (flatcap) <rich@flatcap.org>
" Website:      https://flatcap.org
" Copyright:    2012-2015 Richard Russon
" License:      GPLv3 <http://fsf.org/>
" Version:      1.0

function! s:log_error (msg)
	echohl Error
	echomsg a:msg
	echohl None
endfunction

function! s:log_info (msg)
	echohl CursorLine
	echomsg a:msg
	echohl None
endfunction

function! s:mark_regex (mark, regex, forwards)
	let cursor_pos = getpos ('.')

	" c: accept match at cursor
	" W: don't wrap around
	let l:flags = 'cW'
	if (a:forwards)
		call cursor (1,1)
		let l:stop = 100
	else
		call cursor (100,1)
		let l:stop = 1
		" b: search backwards
		let l:flags .= 'b'
	endif

	let l:success = 0
	if (search (a:regex, l:flags, l:stop, 50) > 0)
		call setpos ("'" . a:mark, getpos ('.'))
		let l:success = 1
	endif

	call setpos ('.', cursor_pos)
	return l:success
endfunction


function! cpp#AddCommentBlock()
	" Create a C function comment
	let l:func = s:get_function_name()

	let @" =  "/**\n" .
		\ ' * ' . l:func . "\n" .
		\ " */\n"

	execute 'normal ""P3j'
endfunction

function! cpp#GetClassName()
	let l:cursor_pos = getpos ('.')

	let l:suffix = expand ('%:e')
	let l:name = ''
	if ((l:suffix == 'h') || (l:suffix == 'hpp'))
		" Header file - search for class definition
		call cursor (1,1)
		if (search ('^class\>.*[^;]$', 'cW', 0, 100) > 0)
			let l:class = getline ('.')
			let l:name = substitute (l:class, 'class\s\+\(\i\+\).*', '\1', '')
		endif
	else
		" Source file - search for constructor
		call cursor (1,1)
		if (search ('\v^(\i+)::\1\s*\(', 'cW', 0, 100) > 0)
			let l:class = getline ('.')
			let l:name = substitute (l:class, ':.*', '', '')
		endif
	endif

	call setpos ('.', l:cursor_pos)

	return l:name
endfunction

function! cpp#GetFunctionName()
	return substitute (getline ('.'), '^.*\%(\s\+\|::\)\(\~\=\w\+\) *(.*', '\1', '')
endfunction

function! cpp#Ifdef (...) range
	if (a:0 == 0)
		let l:ifdef = '#if 0'
	else
		let l:ifdef = '#ifdef ' . a:1
	endif
	call append (a:lastline, '#endif')
	call append (a:firstline-1, l:ifdef)
	call cursor (a:lastline+1, 0)
endfunction

function! cpp#Make()
	" Make and display the quickfix window if necessary
	if (!filereadable ('Makefile') && !filereadable ('makefile'))
		log_error ('No Makefile')
		return
	endif

	execute 'wall'
	execute 'silent !clear'
	execute 'wincmd t'
	execute 'silent make | redraw!'
	if (v:shell_error != 0)
		log_error 'make failed'
		return
	endif
	execute 'botright cwindow 5'

	let l:buf_count = bufnr ('$')
	let l:b = 1
	let l:success = 1
	while l:b <= l:buf_count
		if (bufexists (l:b))
			if (getbufvar (l:b, '&buftype') == 'quickfix')
				execute 'cc'
				execute 'normal zvzz'
				let l:success = 0
				break
			endif
		endif

		let l:b += 1
	endwhile

	if (l:success)
		log_info ('make successful')
	endif
endfunction

function cpp#MarkImportant()
	" Mark ctor, dtor, #include, class
	let l:suffix = expand ('%:e')
	if ((l:suffix == 'h') || (l:suffix == 'hpp'))
		" Header file - search for class definition
		call s:mark_regex ('c', '^class\>.*', 1)
	else
		" Source file - search for constructor
		call s:mark_regex ('c', '\v^(\i+)::\1\s*\(', 1)

		" Source file - search for destructor
		call s:mark_regex ('d', '\v^(\i+)::\~\1\s*\(', 1)
	endif

	" Search for last #include
	call s:mark_regex ('i', '\v^#include', 0)
	if (exists (':SignatureRefresh'))
		execute ':SignatureRefresh'
	endif
endfunction

