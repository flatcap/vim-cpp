" Copyright 2014 Richard Russon (flatcap)
" Mark ctor, dtor, #include, class

function! classname#classname()
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

