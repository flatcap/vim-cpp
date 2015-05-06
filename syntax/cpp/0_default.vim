" source ~/.vim/fold/c.vim

setlocal path=.
setlocal path+=/usr/include
setlocal path+=/usr/include/at-spi2-atk/2.0
setlocal path+=/usr/include/atk-1.0
setlocal path+=/usr/include/atkmm-1.6
setlocal path+=/usr/include/c++/4.8.2/
setlocal path+=/usr/include/cairo
setlocal path+=/usr/include/cairomm-1.0
setlocal path+=/usr/include/freetype2
setlocal path+=/usr/include/gdk-pixbuf-2.0
setlocal path+=/usr/include/gdkmm-3.0
setlocal path+=/usr/include/gio-unix-2.0/
setlocal path+=/usr/include/giomm-2.4
setlocal path+=/usr/include/glib-2.0
setlocal path+=/usr/include/glibmm-2.4
setlocal path+=/usr/include/gtk-3.0
setlocal path+=/usr/include/gtk-3.0/unix-print
setlocal path+=/usr/include/gtkmm-3.0
setlocal path+=/usr/include/harfbuzz
setlocal path+=/usr/include/libdrm
setlocal path+=/usr/include/libpng16
setlocal path+=/usr/include/pango-1.0
setlocal path+=/usr/include/pangomm-1.4
setlocal path+=/usr/include/pixman-1
setlocal path+=/usr/include/sigc++-2.0
setlocal path+=/usr/lib/gcc/x86_64-redhat-linux/4.8.2/include
setlocal path+=/usr/lib64/cairomm-1.0/include
setlocal path+=/usr/lib64/gdkmm-3.0/include
setlocal path+=/usr/lib64/giomm-2.4/include
setlocal path+=/usr/lib64/glib-2.0/include
setlocal path+=/usr/lib64/glibmm-2.4/include
setlocal path+=/usr/lib64/gtkmm-3.0/include
setlocal path+=/usr/lib64/pangomm-1.4/include
setlocal path+=/usr/lib64/sigc++-2.0/include

setlocal noexpandtab
setlocal shiftwidth=8
setlocal tabstop=8
setlocal suffixesadd=.h
setlocal commentstring=//%s

setlocal cindent
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

