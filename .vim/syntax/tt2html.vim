" Vim syntax file
" Language: TT2 ( Inner HTML )
" Last Change:  16 May 2007
" Maintainar:   Atsushi Moriki <4woods+vim@gmail.com>

runtime! syntax/html.vim
unlet b:current_syntax

so <sfile>:p:h/tt2.vim
unlet b:current_syntax
syn cluster htmlPreProc add=@tt2_top_cluster

