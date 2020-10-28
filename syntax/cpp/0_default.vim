" source ~/.vim/fold/c.vim

setlocal   cindent
setlocal   commentstring=//%s
setlocal   expandtab
setlocal   shiftwidth=2
setlocal   suffixesadd=.h
setlocal   tabstop=2

" setlocal cinoptions={.5s,:.5s,+.5s,t0,g0,^-2,e-2,n-2,p2s,(0,=.5s
" setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
" setlocal cinoptions=>4,{1s,n-2,}0,t0,^-2

highlight link cFormat           cString
highlight link cSpecial          cString
highlight link cSpecialCharacter cString
highlight link cCharacter        cString

highlight Constant           ctermfg=123         guifg=#87ffff
highlight cConstant          ctermfg=123         guifg=#87ffff
highlight cppStatement       ctermfg=123         guifg=#87ffff
highlight cRepeat            ctermfg=123         guifg=#87ffff
highlight cppExceptions      ctermfg=123         guifg=#87ffff

highlight cConditional       ctermfg=123         guifg=#87ffff
highlight cDefine            ctermfg=123         guifg=#87ffff
highlight cInclude           ctermfg=123         guifg=#87ffff
highlight cLabel             ctermfg=123         guifg=#87ffff
highlight cOperator          ctermfg=123         guifg=#87ffff
highlight cPreCondit         ctermfg=123         guifg=#87ffff
highlight cPreProc           ctermfg=123         guifg=#87ffff
highlight cStatement         ctermfg=123         guifg=#87ffff
highlight cStorageClass      ctermfg=123         guifg=#87ffff
highlight cStructure         ctermfg=123         guifg=#87ffff
highlight cType              ctermfg=123         guifg=#87ffff
highlight cUserLabel         ctermfg=123         guifg=#87ffff
highlight cppBoolean         ctermfg=123         guifg=#87ffff
highlight cppClassDecl       ctermfg=123         guifg=#87ffff
highlight cppClassPreDecl    ctermfg=123         guifg=#87ffff
highlight cppMethod          ctermfg=123         guifg=#87ffff
highlight cppScopeDecl       ctermfg=123         guifg=#87ffff
highlight cppStorageClass    ctermfg=123         guifg=#87ffff
highlight cppType            ctermfg=123         guifg=#87ffff

highlight cBitField          ctermfg=none        guifg=NONE
highlight cBracket           ctermfg=none        guifg=NONE
highlight cErrInBracket      ctermfg=none        guifg=NONE
highlight cErrInParen        ctermfg=none        guifg=NONE
highlight cError             ctermfg=red         guifg=red cterm=reverse
highlight cFloat             ctermfg=none        guifg=NONE
highlight cMulti             ctermfg=none        guifg=NONE
highlight cNumber            ctermfg=none        guifg=NONE
highlight cNumbers           ctermfg=none        guifg=NONE
highlight cNumbersCom        ctermfg=none        guifg=NONE
highlight cOctal             ctermfg=none        guifg=NONE
highlight cOctalError        ctermfg=Red         guifg=Red
highlight cOctalZero         ctermfg=none        guifg=NONE
highlight cParen             ctermfg=none        guifg=NONE
highlight cParenError        ctermfg=Red         guifg=Red
highlight cSpaceError        ctermbg=18          guibg=#000087
highlight cSpecialError      ctermfg=none        guifg=NONE
highlight cTodo              ctermfg=DarkGreen   guifg=#005000 guibg=#000000 cterm=reverse
highlight cUserCont          ctermfg=none        guifg=NONE

highlight cCppBracket        ctermfg=none        guifg=NONE
highlight cCppParen          ctermfg=red         guifg=red
highlight cppNumber          ctermfg=none        guifg=NONE

syntax match rar "// *RAR.*"
highlight rar ctermfg=207

