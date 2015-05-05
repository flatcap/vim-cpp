" Copyright 2012-2014 Richard Russon (flatcap)

function! ifzero#Ifdef(...) range
	if (a:0 == 0)
		let ifdef = "#if 0"
	else
		let ifdef = "#ifdef " . a:1
	endif
	call append (a:lastline, "#endif")
	call append (a:firstline-1, ifdef)
	call cursor (a:lastline+1, 0)
endfunction

