" Copyright 2012-2015 Richard Russon (flatcap)
" Make and display the quickfix window if necessary
" Mark ctor, dtor, #include, class
" Create a C function comment

function! cpp#classname()
	let cursor_pos = getpos('.')

	let suffix = expand ("%:e")
	if (suffix == 'h')
		" Class
		call cursor(1,1)
		if (search ('^class\>.*[^;]$', 'cW', 0, 100) > 0)
			let class = getline('.')
			let @c = substitute(class, 'class\s\+\(\i\+\).*', '\1', '')
		else
			let @c = ''
		endif
	else
		" Constructor
		call cursor(1,1)
		if (search ('\v^(\i+)::\1\s*\(', 'cW', 0, 100) > 0)
			let class = getline('.')
			let @c = substitute(class, ':.*', '', '')
		else
			let @c = ''
		endif
	endif
	let b:class = @c

	call setpos ('.', cursor_pos)

	XXX return b:class
endfunction

function! s:get_function_name()
	return substitute (getline ('.'), '^.*\%(\s\+\|::\)\(\~\=\w\+\) *(.*', '\1', '')
endfunction

function! cpp#AddCommentBlock()
	let f = s:get_function_name()

	let @" =  "/**\n" .
		\ " * " . f . "\n" .
		\ " */\n"

	execute 'normal ""P3j'
endfunction

function! cpp#Ifdef(...) range
	if (a:0 == 0)
		let ifdef = "#if 0"
	else
		let ifdef = "#ifdef " . a:1
	endif
	call append (a:lastline, "#endif")
	call append (a:firstline-1, ifdef)
	call cursor (a:lastline+1, 0)
endfunction

function! cpp#RichMake()
	if (!filereadable ('Makefile') && !filereadable ('makefile'))
		echohl Error
		echomsg 'No Makefile'
		echohl None
		return
	endif

	execute 'wall'
	execute 'silent !clear'
	execute 'wincmd t'
	execute 'silent make | redraw!'
	if (v:shell_error != 0)
		echohl Error
		echomsg 'make failed'
		echohl None
		return
	endif
	execute 'botright cwindow 5'

	let num = bufnr ('$')
	let b = 1
	let success = 1
	while b <= num
		if (bufexists (b))
			if (getbufvar (b, "&buftype") == "quickfix")
				execute "cc"
				execute "normal zvzz"
				let success = 0
				break
			endif
		endif

		let b = b + 1
	endwhile

	if (success)
		echohl CursorLine
		echom "make successful"
		echohl None
	endif
endfunction

function DUMMY()
	let cursor_pos = getpos('.')

	let suffix = expand ("%:e")
	if (suffix == 'h')
		" Class
		call cursor(1,1)
		if (search ('^class\>.*', 'cW', 0, 100) > 0)
			call setpos ("'c", getpos('.'))
		endif
	else
		" Constructor
		call cursor(1,1)
		if (search ('\v^(\i+)::\1\s*\(', 'cW', 0, 100) > 0)
			call setpos ("'c", getpos('.'))
		endif

		" Destructor
		call cursor(1,1)
		if (search ('\v^(\i+)::\~\1\s*\(', 'cW', 0, 100) > 0)
			call setpos ("'d", getpos('.'))
		endif
	endif

	" #include
	call cursor(200,0)
	if (search ('\v^#include', 'bcW', 0, 50) > 0)
		call setpos ("'i", getpos('.'))
	endif

	call setpos ('.', cursor_pos)

endfunction
