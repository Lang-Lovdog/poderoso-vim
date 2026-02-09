" Vim syntax file
" Language:     Lovdog Dir Tree Format

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
" |               It can be more than one line. ||
" |- dir/         > These descriptions are optional

" --- Core Elements ---
syntax match liotreeLateralBar /|/ contained
syntax match liotreeDepthMark  /[-+]\+/ contained
syntax match liotreeRootMarker /|/ 

" --- Quoted Names ---
" Matches "Name"/ (Directory) or "Name" (File)
syntax region liotreeQuotedDirname  start=/["']/ end=/["']\// contained oneline contains=liotreeQuotedContent,@NoSpell
syntax region liotreeQuotedFilename start=/["']/ end=/["']/  contained oneline contains=liotreeQuotedContent,@NoSpell
syntax match  liotreeQuotedContent  /[^"']\+/ contained contains=@NoSpell

" --- Unquoted Names (Now supports spaces/special chars until the '>' comment) ---
" Directory: text ending in / before a comment or EOL
syntax match liotreeUnquotedDirname /[^-+|>][^|>]\+\/\ze\(\s*>\|$\)/ contained contains=@NoSpell
" File: text not ending in / before a comment or EOL
syntax match liotreeUnquotedFilename /[^-+|>][^|>]\+\ze\(\s*>\|$\)/  contained contains=@NoSpell

" --- Comments ---
syntax match liotreeInlineComment />.*$/ contained contains=@Spell
syntax match liotreeCommentEnd     /||$/ contained

" --- Line Definitions ---
" Structure Line: |- Filename  > Comment
syntax match liotreeStructureLine /^\s*|[-+]\+\s\+.*$/ transparent
    \ contains=liotreeLateralBar,liotreeDepthMark,liotreeQuotedDirname,liotreeQuotedFilename,liotreeUnquotedDirname,liotreeUnquotedFilename,liotreeInlineComment,@Spell

" Root Line: |Filename  > Comment
syntax match liotreeRootLine /^\s*|[^-+ ]\+.*$/  transparent
    \ contains=liotreeRootMarker,liotreeUnquotedDirname,liotreeUnquotedFilename,liotreeInlineComment,@Spell

" Pure Comment Line: |  Description text
syntax match liotreeCommentLine /^\s*|\s\{2,}.*$/ 
    \ contains=liotreeLateralBar,liotreeCommentEnd,@Spell

" --- The Error Fix ---
" Only flags if a line starts with tree structure but has a quote that never closes
syntax match liotreeError /^\s*|[-+]*\s*["'][^"']*$/

" --- Highlighting Links ---
highlight link liotreeLateralBar        Type
highlight link liotreeStructureLine     Keyword
highlight link liotreeDepthMark         Statement
highlight link liotreeRootMarker        Type
highlight link liotreeQuotedDirname     Directory
highlight link liotreeUnquotedDirname   Directory
highlight link liotreeQuotedFilename    Keyword
highlight link liotreeUnquotedFilename  Identifier
highlight link liotreeInlineComment     Comment
highlight link liotreeCommentLine       Comment
highlight link liotreeCommentEnd        Special
highlight link liotreeError             Error

let &cpoptions = s:cpo_orig
unlet s:cpo_orig

setlocal spell
