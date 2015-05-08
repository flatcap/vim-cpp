" source ~/.vim/fold/c.vim

setlocal   cindent
setlocal   commentstring=//%s
setlocal noexpandtab
setlocal   shiftwidth=8
setlocal   suffixesadd=.h
setlocal   tabstop=8

" setlocal cinoptions={.5s,:.5s,+.5s,t0,g0,^-2,e-2,n-2,p2s,(0,=.5s
" setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
" setlocal cinoptions=>4,{1s,n-2,}0,t0,^-2

highlight link cFormat           cString
highlight link cSpecial          cString
highlight link cSpecialCharacter cString
highlight link cCharacter        cString

highlight Constant           ctermfg=123
highlight cConstant          ctermfg=123
highlight cppStatement       ctermfg=123
highlight cRepeat            ctermfg=123
highlight cppExceptions      ctermfg=123

highlight cConditional       ctermfg=123
highlight cDefine            ctermfg=123
highlight cInclude           ctermfg=123
highlight cLabel             ctermfg=123
highlight cOperator          ctermfg=123
highlight cPreCondit         ctermfg=123
highlight cPreProc           ctermfg=123
highlight cStatement         ctermfg=123
highlight cStorageClass      ctermfg=123
highlight cStructure         ctermfg=123
highlight cType              ctermfg=123
highlight cUserLabel         ctermfg=123
highlight cppBoolean         ctermfg=123
highlight cppClassDecl       ctermfg=123
highlight cppClassPreDecl    ctermfg=123
highlight cppMethod          ctermfg=123
highlight cppScopeDecl       ctermfg=123
highlight cppStorageClass    ctermfg=123
highlight cppType            ctermfg=123

highlight cBitField          ctermfg=none
highlight cBracket           ctermfg=none
highlight cErrInBracket      ctermfg=none
highlight cErrInParen        ctermfg=none
highlight cError             ctermfg=red cterm=reverse
highlight cFloat             ctermfg=none
highlight cMulti             ctermfg=none
highlight cNumber            ctermfg=none
highlight cNumbers           ctermfg=none
highlight cNumbersCom        ctermfg=none
highlight cOctal             ctermfg=none
highlight cOctalError        ctermfg=Red
highlight cOctalZero         ctermfg=none
highlight cParen             ctermfg=none
highlight cParenError        ctermfg=Red
highlight cSpaceError        ctermbg=18
highlight cSpecialError      ctermfg=none
highlight cTodo              ctermfg=DarkGreen cterm=reverse
highlight cUserCont          ctermfg=none

highlight cCppBracket        ctermfg=none
highlight cCppParen          ctermfg=red
highlight cppNumber          ctermfg=none

syntax match rar "// *RAR.*"
highlight rar ctermfg=207

