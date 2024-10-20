" Copyright 2001-2019 Richard Russon.

let s:function_global   = '●'
let s:function_static   = '○'

let s:neo_fold_proto    = 1
let s:neo_hide_name     = 1
let s:neo_show_args     = 1
let s:neo_show_icon     = 1
let s:neo_show_lines    = 0
let s:neo_show_return   = 0

let s:abbreviation      = '…'
let s:prefix_array      = '□'
let s:prefix_comment    = '▶ '
let s:prefix_copyright  = '© Copyright'
let s:prefix_define     = '♯'
let s:prefix_enum       = '☰'
let s:prefix_function   = '●'
let s:prefix_struct     = '⧋'
let s:prefix_union      = '∪'


function! s:FoldCopyright (lnum)
	let line = s:prefix_copyright

	if ((s:neo_show_lines == 1) && (v:foldlevel > 2))
		let num = v:foldend - v:foldstart
		let line = line . ' {' . num . '}'
	endif

	return line
endfunction

function! s:FoldFunction (lnum)
	let func = ''
	for i in range (a:lnum, a:lnum+8)
		let line = getline(i)
		if (line[0] == '{')
			break
		endif
		let func .= line
	endfor

	let func = substitute (func, '^static ', '', '')

	if (s:neo_show_args == 1)
		let func = substitute (func, ', *[^,]\+[ *]', ',', 'g')
		let func = substitute (func, '( *[^,]\+[ *]', '(', '')
	else
		let func = substitute (func, '(.*', '', '')
	endif

	if (s:neo_show_return == 1)
		let func = substitute (func, '\(.\{-\}\**\) *\(\<\i\+\((.*\)*\)$', '\2 -> \1', '')
	else
		let func = substitute (func, '.*\(\<\i\+\((.*\)*\)$', '\1', '')
	endif

	let pre2 = getline (a:lnum - 2)
	let prev = getline (a:lnum - 1)
	let prev = substitute (prev, '\s*/\*.\{-\}\*/$', '', '') " strip one-line comments
	let prev = substitute (prev, '#.*', '', '')              " strip pre-processor
	if ((s:neo_hide_name == 1) && (prev == ' */') && (pre2 =~ '^ \* '))
		let func = substitute (func, '\i\+(', '  (', '')
	endif

	return func
endfunction

function! s:FoldComment (lnum)
	let list = []
	let line = getline (a:lnum)

	" Keep track of the leading whitespace (converted to spaces)
	let space = substitute (line, '\(\s*\).*', '\1', '')
	let space = substitute (space, '\t', '        ', 'g')

	" Trim opening comment marker /* or /**
	let line = substitute (line, '^\s*/\*\+\s*', '', '')
	if (!empty (line))
		let list += [ line ]
	endif

	" Examine the next three lines
	for i in range (a:lnum+1, a:lnum+3)
		let line = getline(i)
		let line = substitute (line, '\v(struct|enum) ', '', '')
		if (line =~ '^\s*\*\/\s*$')
			" Found */ stop here
			break
		endif
		if (line =~ '\v \* \@(param|retval)')
			" Found Doxygen comment stop here
			break
		endif
		" Trim leading whitespace and comment marker *
		let line = substitute (line, '^\s*\*\+\s*', '', '')
		if (empty (line))
			break
		endif
		if (line == '.pp')
      continue
    endif
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

	let comment = substitute (join (list, " "), '\s\+', ' ', 'g')
	let comment = substitute (comment, '[-=]\{3,\}', '', 'g')
	let comment = substitute (comment, '\v\s*(.*\S)\s*', '\1', 'g')
	let result = space . s:prefix_comment . comment

	" Truncate comment to screen width
	" This doesn't take into account foldcolumn and numberwidth settings
	let c = min ([winwidth(0), 80]) - 4
	if (len (result) > c)
		let result = result[0:c] . s:abbreviation
	endif

	return result
endfunction

function! s:FoldInclude (linenum, count)
	let line = '#include'
	if ((s:neo_show_lines == 1) && (v:foldlevel > 2))
		let num = v:foldend - v:foldstart
		let line = line . ' {' . num . '}'
	endif

	return line
endfunction

function! s:FoldGetFunctionIcon (lnum)

	for i in range (a:lnum, a:lnum+20)
		let line = getline(i)
		if (line =~ '^}')
			break
		elseif (line =~ '^static.*')
			return s:function_static
		elseif (line =~ '\v^(typedef )*enum[^(]*$')
			return s:prefix_enum
		elseif (line =~ '\v^(typedef )*struct[^(]*$')
			return s:prefix_struct
		elseif (line =~ '\v^(typedef )*union[^(]*$')
			return s:prefix_union
		elseif (line =~ '^__attribute__.*')
			continue
		endif
	endfor

	return s:prefix_function
endfunction

function! cpp_fold#FoldText (lnum)
	let prev = getline (a:lnum - 1)
	let line = getline (a:lnum)
	let next = getline (a:lnum + 1)

	if ((line =~ '^/\* Copyright.*') || (next =~ '^ \* Copyright.*'))
		let text = s:FoldCopyright (a:lnum)
		return text
	endif

	if ((line =~ '^#if.*') && (next =~ '^/\*\*$'))
    let line = next
    let next = getline (a:lnum + 2)
  endif

	if (line =~ '^/\*\*$')
		if (next =~ '^ \* @.*')
			return s:FoldComment (a:lnum)
		endif
		" Function block
		let next = substitute (next, '^\s\+\*\s*', '', '')
		let next = substitute (next, '\v<(struct|enum)> *', '', '')
		let next = substitute (next, ' - Implements.*', '', '')
		let icon = s:FoldGetFunctionIcon (v:foldstart+1)

		if (s:neo_show_lines == 1)
			let num = v:foldend - v:foldstart
			let next = next . ' {' . num . '}'
		endif

		return icon . ' ' . next
	endif

	if (line =~ '^#define')
		let line = substitute (line, '#define \(\i\+\)\((.\{-\})\)*.*', '\1\2', '')
		return s:prefix_define . line
	endif

	if (line =~ ' = {$')
		let line = substitute (line, ' = {', '', '')
		let line = substitute (line, '^static *', '', '')
		let line = substitute (line, '^const *', '', '')
		let line = substitute (line, '^typedef *', '', '')
		let line = substitute (line, '^enum *', '', '')
		let line = substitute (line, '^struct *', '', '')
		let line = substitute (line, '^union *', '', '')
		if (line =~ '\]$')
			let line = s:prefix_array . ' ' . line
		else
			let line = s:prefix_struct . ' ' . line
		endif

		if (s:neo_show_lines == 1)
			let num = v:foldend - v:foldstart
			let line = line . ' {' . num . '}'
		endif

		return line
	endif

	if (line =~ '^#include')
		let num = v:foldend - v:foldstart
		return s:FoldInclude (a:lnum, num)
	endif

	if (line =~ '^\s*/\*.*')
		return s:FoldComment (a:lnum)
	endif

	if ((prev == '') && (line !~ '^\S.*(.*$'))
		" no comment block
		let icon = s:FoldGetFunctionIcon (v:foldstart)
		let line = substitute (line, ' {$', '', '')
		if (line =~ '^typedef')
			let name = getline(v:foldend - 1)
			let name = substitute (name, '} \(\i\+\);', '\1', '')
		else
			let name = ''
		endif
		let line = substitute (line, '\v^(typedef )*(struct|enum|union) *', '', '')
		if ((line == '') && (name == ''))
			let line = 'anonymous'
		elseif (name != '')
			let line = name
		endif
		return icon . ' ' . line
	endif

	let line = s:FoldFunction(a:lnum)

	if (s:neo_show_icon == 1)
		if (getline (a:lnum) =~ '^static.*')
			let line = s:function_static . ' ' . line
		else
			let line = s:function_global . ' ' . line
		endif
	endif

	if ((s:neo_show_lines == 1) && (v:foldlevel < 2))
		let num = v:foldend - v:foldstart
		let line = line . ' {' . num . '}'
	endif

	return line
endfunction

function! cpp_fold#FoldLevel (lnum)
	let pre2 = getline (a:lnum - 2)
	let prev = getline (a:lnum - 1)
	let line = getline (a:lnum)
	let next = getline (a:lnum + 1)
	let nex2 = getline (a:lnum + 2)

	" multi-line #define
	if (line =~ '^#define.*\\$')
		return '>2'
	elseif (line =~ '\\$')
		return '='
	elseif ((line == '') && (pre2 =~ '\\$'))
		return '<1'
	endif

	" #define block
	if ((prev == '') && (line =~ '^#define ') && (next =~ '^#define '))
		return '3'
	elseif ((line == '') && (prev =~ '^#define '))
		return '0'
	endif

	" #include block
	if ((prev == "") && (line =~ '^#include'))
		return 'a1'
	elseif ((line == '') && ((prev =~ '^#include') || ((prev =~ '#endif') && (pre2 =~ '^#include'))))
		return '0'
	endif

	if ((pre2[0] == '}') && (prev =~ '^#endif.*') && (line == ''))
	 	return '<1'
  endif

  " #if + top-level block comment, doxygen style
	if ((line =~ '^#if.*') && (next =~ '^/\*\*$') && (nex2 =~ '^ \* \i\+ - .*'))
    return '>2'
  endif

  " #if + top-level block comment, doxygen style
	if ((prev =~ '^#if.*') && (line =~ '^/\*\*$'))
    return '='
  endif

	" ignore preprocessor commands
	if (line =~ '^#')
		return '='
	endif

	" ignore one-line C comments (no code)
	if ((line =~ '^.*/\*\*< .* \*\/$') || (line =~ '^\s*/\*.*\*/$'))
		return '='
	endif

	" filter out remaining one-line comments
	let prev = substitute (prev, '\s\+/\*.*\*/', '', 'g')
	let line = substitute (line, '\s\+/\*.*\*/', '', 'g')

	" " Very specific comment blocks
	" if (line =~ '^/\* Copyright.*')
	" 	return '>4'

	" block comments
	if (line =~ '^/\*\*$')    " top-level, doxygen style
    if (next =~ '^ \* \i\+ - .*')
      return '>2'
    else
      return '>3'
    endif
	elseif (line =~ '^/\*')       " top-level, unformatted
		return '>3'
	elseif (line =~ '^\s*/\*.*$') " in-code
		return 'a1'

	" " Multi-line function prototype
	" elseif (line =~ '^\S.*(.*[^)]$')
	" 	for i in range (a:lnum + 1, a:lnum + 8)
	" 		let l = getline(i)
      " if (l == '')
        " return '='
      " elseif (l[0] == '{')
	" 			return '>2'
	" 		endif
	" 	endfor

	" " Single-line function prototype
	" elseif (line =~ '^\S.*(.*)$')
	" 	return '2'

	elseif (line =~ ' = {$')
		return '1'
	elseif (prev == '};')
		return '<1'

	" elseif (line =~ '\v^(typedef )*(enum|struct|union)')
	" 	return '1'

	elseif ((prev == "") && (next == '{'))
		return 'a1'

	elseif (line == '{')
		return '1'

	elseif ((prev[0] == '}') && (line == ''))
	 	return '<1'

	elseif ((line =~ '^ \*/') && (a:lnum < 30))
		return '='

	" " Isolated comment block
	" elseif ((prev =~ ' \*/') && (line == ''))
	" 	return 's1'

	elseif (line =~ '\*/')
		return '<2'

	endif

	return '='
endfunction


hi foldcolumn guibg=#303030
set foldmethod=expr
set foldexpr=cpp_fold#FoldLevel(v:lnum)
set foldtext=cpp_fold#FoldText(v:foldstart)
" set foldlevel=3
" set foldcolumn=4
