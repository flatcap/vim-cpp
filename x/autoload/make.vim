" Copyright 2012-2014 Richard Russon (flatcap)
"
" Make and display the quickfix window if necessary

function! make#RichMake()
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

