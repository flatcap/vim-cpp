" Copyright 2014 Richard Russon (flatcap)
" Mark ctor, dtor, #include, class

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

