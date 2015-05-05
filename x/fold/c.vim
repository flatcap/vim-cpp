" Copyright 2001-2014 Richard Russon.

source ~/.vim/fold/deffold.vim

if ($QV == 1)
	finish
endif

let s:prefix_comment   = '--> '
let s:prefix_function  = 'F)'
let s:abbreviation     = '...'

let s:prefix_ctor	= 'ctor'
let s:prefix_dtor	= 'dtor'

let s:prefix_copyright	= '© Copyright'

let s:function_method	= '●'
let s:function_local	= '○'
let s:function_static	= '∗'

" TODO:
"     count the number of function parameters (@arg)
"     look for keywords like: static, inline, etc

" Determine if the code needs folding
function! C_FoldLevel(lnum)
	let prev = getline (a:lnum - 1)
	let line = getline (a:lnum)
	let next = getline (a:lnum + 1)
	let nex2 = getline (a:lnum + 2)
	let nex3 = getline (a:lnum + 3)

	" Very specific comment blocks
	elseif (line =~ '^/\* Copyright.*')
		let level = '>2'
	elseif ((line =~ '^/\*\*\=') && (next =~ '^ \* SECTION:.*'))
		let level = '>1'

	" Function/Signal/Property comment block
	elseif ((line =~ '^\s\+/\*\*\=') && (next =~ '^\s\+\* [_a-zA-Z]\+::\=.*'))
		let level = 'a1'
	elseif ((line =~ '^/\*\*.*') && (next =~ '^ \* [~_a-zA-Z]\+.*'))
		let level = '>2'
	elseif ((line =~ '^/\*\*\=.*') && (next =~ '^ \* [_a-zA-Z]\+.*') && (nex2 =~ '^ \* @[_a-zA-Z]\+.*'))
		let level = '>2'
	"elseif ((line =~ '^/\*\*\=.*') && (next =~ '^ \* [_a-zA-Z]\+:.*'))
	"	let level = '>2'

	" Normal comment blocks
	elseif ((line =~ '^.*/\*.*'))
		let level = 'a1'

	elseif ((line =~ '^template.*') && (nex3 =~ '^{$}'))
		echom "template"
		let level = 'a1'

	" End of folds
	elseif ((prev =~ '^ \*/') && (a:lnum < 20) && (getline (1) =~ "^/*"))
		let level = 0
	elseif ((line =~ '^.*\*/') && (next !~ '^$'))
		let level = 's1'
	elseif ((prev =~ '^.*\*/') && (line =~ '^$'))
		let level = 's1'
	elseif (prev[0] == '}')
		let level = '<1'

	else
		let level = '='
	endif
	return level
endfunction

" Fold a copyright message
function! C_FoldCopyright(lnum)
	if (&foldlevel < 2)
		return s:prefix_copyright
	endif

	let line = getline (a:lnum)
	let line = substitute (line, '^/\* Copyright (c) \d\d\d\d\(-\d\d\d\d\)\? ', '', '')
	return s:prefix_copyright . ' ' . line
endfunction

" Read a function's comment block and abbreviate it.
function! C_FoldFunction(lnum)
	let desc = getline (a:lnum)
	let desc = substitute (desc, '^ \* *', '', '')
	let endline = getline (foldclosedend(a:lnum))
	if (endline =~ '^.*\*/')
		let desc = s:prefix_comment . desc
	else
		let desc = s:prefix_function . desc
		let s = v:foldend - v:foldstart + 1
		let desc = desc . ' ('.s.')'
	endif
	return desc
endfunction

" We've found a block comment, so abbreviate it.
" If it stretches to more than one line, append '...'
function! C_FoldComment(lnum)
	let list = []
	let line = getline (a:lnum)

	" Keep track of the leading whitespace (converted to spaces)
	let space = substitute (line, '\(\s*\).*', '\1', '')
	let space = substitute (space, '\t', '        ', 'g')

	" Trim opening comment marker /* or /**
	let line = substitute (line, '^\s\+/\*\+\s*', '', '')
	if (!empty (line))
		let list += [ line ]
	endif

	" Examine the next three lines
	for i in range (a:lnum+1, a:lnum+3)
		let line = getline (i)
		if (line =~ '^\s\+\*\/\s*$')
			" Found */ stop here
			break
		endif
		" Trim leading whitespace and comment marker *
		let line = substitute (line, '^\s\+\*\s*', '', '')
		if (line =~ '.*\*\/\s*$')
			" Line ends */ trim it and leading whitespace
			let line = substitute (line, '\*/\s*$', '', '')
			let list += [ line ]
			break
		endif

		if (!empty (line))
			let list += [ line ]
		endif
	endfor

	let result = space . s:prefix_comment . join(list, " ")

	" Truncate comment to screen width
	" This doesn't take into account foldcolumn and numberwidth settings
	let c = min ([winwidth(0), 80]) - 4
	if (len(result) > c)
		let result = result[0:c] . "..."
	endif

	return result
endfunction

" Determine the type of comment, then abbreviate it.
function! C_FoldInclude(line, count)
	if (&foldlevel < 2)
		return '#include'
	endif

	if (a:line =~ '^#include ".*')
		let text = '""'
	elseif (a:line =~ '^#include <.*\.h>')
		let text = '<h>'
	else
		let text = '<>'
	endif

	let text = '#include ' . text . ' (' . a:count . ')'
	return text
endfunction

function! C_FoldCtor (text)
	let class = substitute (a:text, '::.*', '\1', '')
	let ctor  = substitute (a:text, '^\(.*\)::\1\s*', '', '')

	if ((ctor == "()") || (ctor == "(void)"))
		let ctor = "default"
	elseif (ctor =~ "(" . class . '&&\s*\i.*')
		let ctor = "move"
	elseif (ctor =~ '(const ' . class . '&\s*\i.*')
		let ctor = "copy"
	else
		let ctor = "other"
	endif

	return s:prefix_ctor ." (" . ctor . ")"
endfunction

function! C_FoldOperator (text)
	let class = substitute (a:text, '::.*', '\1', '')
	let oper  = substitute (a:text, '^\i\+::\(\S\+\).*', '\1', '')
	let args  = substitute (a:text, '^[^(]\+', '', '')

	if (args =~ "(" . class . '&&\s*\i.*')
		let type = "move"
	elseif (args =~ '(const ' . class . '&\s*\i.*')
		let type = "copy"
	else
		let type = "other"
	endif

	return oper . " (" . type . ")"
endfunction

function! C_FoldFunction2(lnum)
	let text = "Function!"
	let static = 0
	for i in range(0,4)
		let line = getline (a:lnum+i)
		if (line =~ '^static.*')
			let static = 1
		elseif (line =~ '^__attribute__.*')
			continue
		elseif (line =~ '.*(.*')
			break
		endif

	endfor
	if (line =~ '^\i\+::\~*\i\+[=]*\s*(.*')
		let text = substitute (line, '\s*(.*', '', '')

		if (text =~ '^\C\(.*\)::\1')
			let text = C_FoldCtor (line)
		elseif (text =~ '^\C\(.*\)::operator.*')
			let text = C_FoldOperator (line)
		elseif (text =~ '^\C\(.*\)::swap')
			let text = 'swap (member)'
		elseif (text =~ '^\(.*\)::\~\1')
			let text = substitute (text, '^\(.*\)::\~\1', s:prefix_dtor, '')
		else
			let text = substitute (text, '^.*::', '', '')
		endif
		let text = s:function_method . ' ' . text
	else
		let text = substitute (line, '\s*(.*', '', '')
		if (line =~ '^\Cswap\s*(.*')
			let text .= " (global)"
		endif
		if (static)
			let text = s:function_static . ' ' . text
		else
			let text = s:function_local . ' ' . text
		endif
	endif
	return text
endfunction

function! C_FoldGetFunctionIcon(lnum)

	for i in range(a:lnum,a:lnum+20)
		let line = getline(i)
		if (line =~ '^static.*')
			return s:function_static
		elseif (line =~ '^__attribute__.*')
			continue
		elseif (line =~ '^\i\+::\~*\i\+\s*(.*')
			return s:function_method
		elseif (line =~ '^\i\+::operator.*')
			return s:function_method
		elseif (line =~ '^operator.*')
			return s:function_local
		elseif (line =~ '^\i\+\s*(.*')
			return s:function_local
		endif
	endfor

	return s:prefix_function
endfunction

" Determine the type of comment, then abbreviate it.
function! C_FoldText(lnum)
	let prev = getline (a:lnum - 1)
	let line = getline (a:lnum)
	let next = getline (a:lnum + 1)
	let nex2 = getline (a:lnum + 2)
	let nex3 = getline (a:lnum + 3)

	" if (prev =~ '^\s\+for\s(.*')
	" 	let s = v:foldend - v:foldstart - 1
	" 	let line = substitute (line, '\t', '        ', 'g')
	" 	if (1)
	" 		let line = substitute (line, '[^ ].*', '', '')
	" 		return line . s . " lines..."
	" 	else
	" 		if (0)
	" 			let line = substitute (line, '\s*{.*', '', '')
	" 			return line . " {" . s . " lines}"
	" 		else
	" 			let line = substitute (line, '\s*(.*', '', '')
	" 			return line . " (" . s . " lines)"
	" 		endif
	" 	endif
	" endif

	"return v:foldlevel . " " . v:foldstart . " " . v:foldend

	if (line =~ "^#include.*")
		let s = v:foldend - v:foldstart
		return C_FoldInclude(line, s)
	endif

	if ((line =~ '^/\* Copyright.*'))
		let text = C_FoldCopyright(a:lnum)
		return text
	endif

	if (line =~ '^\s\+/\*.*')
		return C_FoldComment (a:lnum)
	endif

	if ((line =~ '^public:') || (line =~ '^protected:') || (line =~ '^private:'))
		if (line =~ '^\i\+:\s*//.*')
			return substitute (line, ':.*// *', ': ', '')
		elseif (next =~ '^\s\+//.*')
			return line . substitute (next, '^\s\+//\s*', ' ', '')
		else
			return substitute (line, ':.*', ': ', '')
		endif
	endif

	if (line =~ '^/\*\*$')
		" Function block
		let next = substitute (next, '^\s\+\*\s*', '', '')
		let icon = C_FoldGetFunctionIcon (v:foldstart+1)
		return icon . ' ' . next
	endif

	return C_FoldFunction2(a:lnum)

"	elseif ((line =~ '^/\*\*\=') && (next =~ '^ \* SECTION:.*'))
"		let text = C_FoldSection(a:lnum + 1)
"	elseif ((line =~ '^\s\+/\*\*\=') && (next =~ '^\s\+\* [_a-zA-Z]\+::\=.*'))
"		let text = C_FoldSigProp(a:lnum + 1)
"
"	elseif ((line =~ '^/\*\*.*') && (next =~ '^ \* [~_a-zA-Z]\+.*'))
"		let text = C_FoldFunction(a:lnum + 1)
"	elseif ((line =~ '^/\*\*\=.*') && (next =~ '^ \* [_a-zA-Z]\+.*') && (nex2 =~ '^ \* @[_a-zA-Z]\+.*'))
"		let text = C_FoldFunction(a:lnum + 1)
"	"elseif ((line =~ '^/\*\*\=.*') && (next =~ '^ \* [_a-zA-Z]\+:.*'))
"	"	let text = C_FoldFunction(a:lnum + 1)
"
"	elseif ((line =~ '^template.*') && (nex3 =~ '^{$}'))
"		let text = nex2
"
"	else
"		let text = C_FoldComment(a:lnum)
"	endif
"
"	return text
endfunction

function! C_FoldLevel2(lnum)
	let prev = getline (a:lnum - 1)
	let line = getline (a:lnum)
	let next = getline (a:lnum + 1)
	let nex2 = getline (a:lnum + 2)
	let nex3 = getline (a:lnum + 3)
	let nex4 = getline (a:lnum + 4)
	let nex5 = getline (a:lnum + 5)	" enough for 6 lines of preamble

	let prev = substitute (prev, '/\*[^*]*\*/', '', '')
	if ((prev[0] == '#') && (line[0] != '#'))
		let prev = substitute (prev, '#\(if\|else\|endif\).*', '', '')
	endif

	" Ignore one-line C comments
	if (line =~ '^\s*/\*.*\*/.*$')
		return '='
	endif

	let line = substitute (line, '\s*/\*[^*]*\*/\s*', '', '')

	if ((line =~ '^template.*') && (nex3 =~ '^{$'))
		let level = 'a1'

	elseif ((prev == "") && (line =~ '^\S.*(.*') && ((next == '{') || (nex2 == '{') || (nex3 == '{') || (nex4 == '{')))
		let level = 'a1'

	elseif ((prev == "") && (line != "") && (next =~ '.*(.*') && (nex2 == '{'))
		let level = 'a1'

	elseif ((prev == "") && (line =~ '^.* \i\+\s*=\s*{$'))
		let level = 'a1'

	" Very specific comment blocks
	elseif (line =~ '^/\* Copyright.*')
		let level = '>4'

	elseif (line =~ '^/\*\*$')
		let level = '>2'

	elseif (line =~ '^\s\+/\*.*$')
		let level = 'a1'

	elseif (line =~ '/\*\( .*\)\?$')
		let level = 'a1'
	elseif (line =~ '/\*\s')
		let level = 'a1'

	elseif ((prev == "") && (line =~ '^#include.*'))
		let level = '>3'

	elseif ((prev =~ '^#include.*') && (line == ""))
		if (next =~ '^#include.*')
			let level = '<3'
		else
			let level = 0
		endif

	elseif ((line =~ '^#include.*') && (next == "") && (nex2 !~ '^#include'))
		let level = '<1'

	elseif ((prev =~ '^ \*/') && (a:lnum < 20) && (getline(1) =~? '^/\* Copyright.*'))
		let level = '<1'

	elseif (line =~ '\*/')
		let level = 's1'

	elseif ((line[0] == '}') && (next =~ "#endif.*"))
		let level = '<1'

	elseif ((prev =~ '^}') && (line == ""))
		let level = '<1'

	elseif ((line =~ '^public:') || (line =~ '^protected:') || (line =~ '^private:'))
		let level = 'a1'
	elseif ((line != '{') && ((next =~ '^public:') || (next =~ '^protected:') || (next =~ '^private:')))
		let level = 's1'
	" elseif ((v:foldlevel == 1) && (line =~ '^};$'))
	" 	let level = 0

	else
		let level = '='
	endif
	return level
endfunction


" Enable folding.
set foldexpr=C_FoldLevel2(v:lnum)
set foldtext=C_FoldText(v:foldstart)

