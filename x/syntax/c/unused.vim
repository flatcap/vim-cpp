
" Working
syntax region U_surround matchgroup=U_variable start="UNUSED(" skip="\i\+" end=")" concealends cchar=†
highlight U_surround ctermfg=none
highlight U_variable ctermfg=red
" 0	function (string& UNUSED(filename))
" 1	function (string&  filename )
" 1	function (string&  filename⊙)
" 2	function (string& filename)
" 2	function (string& filename⊙)
" 3	function (string& filename)

" Working
" syntax region U_variable matchgroup=U_brackets start="UNUSED("lc=6 skip="\i\+" end=")" conceal
" syntax match U_unused "UNUSED"
" highlight U_unused ctermfg=red
" highlight U_variable ctermfg=yellow
" highlight U_brackets ctermfg=blue
" 0	function (string& UNUSED(filename))
" 1	function (string& UNUSED   )
" 1	function (string& UNUSED ⊙⊙)
" 2	function (string& UNUSED)
" 2	function (string& UNUSED⊙⊙)
" 3	function (string& UNUSED)

" Working
" syntax match U_all "\s*UNUSED\s*(\i\+)\s*" conceal
" highlight U_all ctermfg=red
" 0	function (string& UNUSED(filename))
" 1	function (string& )
" 1	function (string&⊙)
" 2	function (string&)
" 2	function (string&⊙)
" 3	function (string&)

