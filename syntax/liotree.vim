" Vim syntax file
" Language:     Lovdog Dir Tree Format
" License:      VIM LICENSE

if exists('b:current_syntax')
  finish
endif

let s:cpo_orig=&cpoptions
set cpoptions&vim

let b:current_syntax = 'liotree'

syntax sync minlines=100

" Depth Mark for the tree structure with '-' and or '+'
" each level should be denoted by more '-' or '+'
" If wanted, the lateral bar for more formal view
" the names should be ended by a '/' if it's a dir, if not then its a file
" If needed, a comment should be added starting by a '>', and if breaking
" the line, just continue with a '|' and aligned with the comment line above.
" If levels mismatch, for example a 3rd level after a 1st level or a next
" level after a file, it's not valid syntax, should be error marked.
" |root/
" |- level1/
" |-- level2/
" |--- level3/
" |-- file        > File description, it can be whatever
" |               the file should be correctly aligned.
" |               It can be more than one line.
" |- dir/

" Core elements
syntax match liotreeLateralBar /^\s*\zs|/ contained
syntax match liotreeDepthMark  /^\s*\zs[-+]\+\ze\s/ contains=liotreeLateralBar
syntax match liotreeRootMarker /^\s*\zs|/  " Root level marker

" Directory and file names
syntax match liotreeDirname    /^\s*\zs[-+]\+\ze\s\+\zs[^/]\+\/\ze\s*$/ contains=liotreeDepthMark
syntax match liotreeFilename   /^\s*\zs[-+]\+\ze\s\+\zs[^/]\+\ze\s*$/   contains=liotreeDepthMark
syntax match liotreeRootDir    /^\s*\zs|\ze[^|-+][^/]*\//               contains=liotreeRootMarker
syntax match liotreeRootFile   /^\s*\zs|[^/]\+\ze\s*$/                  contains=liotreeRootMarker

" Comments
syntax match liotreeCommentStart /^\s*>.*$/ contained
syntax match liotreeCommentCont  /^\s*|.*$/ contained
syntax region liotreeComment start=/^\s*>/ end=/^\ze\s*[^-+>|]/me=e-1 contains=liotreeCommentStart,liotreeCommentCont
syntax region liotreeCommentBlock start="\s*>.*$" end="\ze\s*[^-+>|]" contained contains=liotreeCommentLine,liotreeCommentCont keepend

" Errors (simplified)
syntax match liotreeError /^\s*[|][-+]*[^| \t\r\n\/][^\/]*\/\?/  " Malformed lines

" Highlight links
highlight link liotreeLateralBar   Delimiter
highlight link liotreeDepthMark    Special
highlight link liotreeRootMarker   Type
highlight link liotreeDirname      Directory
highlight link liotreeFilename     Normal
highlight link liotreeRootDir      Directory
highlight link liotreeRootFile     Normal
highlight link liotreeCommentStart Comment
highlight link liotreeCommentCont  Comment
highlight link liotreeComment      Comment
highlight link liotreeError        Error
