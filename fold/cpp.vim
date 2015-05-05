let g:rich_wip += 1
echohl error
echom printf ('seq %d, file %s', g:rich_wip, expand('<sfile>:p'))
echohl none
