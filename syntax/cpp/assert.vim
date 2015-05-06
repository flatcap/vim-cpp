syntax region assert_test matchgroup=assert_surround start="return_\(val_\)\=if_fail *(" skip="[^)]\+" end=");" concealends cchar=✓
highlight assert_test     ctermfg=green
highlight assert_surround ctermfg=magenta
