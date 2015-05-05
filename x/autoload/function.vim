" Copyright 2012-2014 Richard Russon (flatcap)
"
" Create a C function comment

function! s:get_function_name()
	return substitute (getline ('.'), '^.*\%(\s\+\|::\)\(\~\=\w\+\) *(.*', '\1', '')
endfunction

function! function#CommentBlock()
	let f = s:get_function_name()

	let @" =  "/**\n" .
		\ " * " . f . "\n" .
		\ " */\n"

	execute 'normal ""P3j'
endfunction

