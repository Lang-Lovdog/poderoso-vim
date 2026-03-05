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
" |- dir/         > These descriptions are optional ||

" --- Core Elements ---
syntax match liotreeLateralBar /|/    contained conceal cchar=├
syntax match liotreeDepthMark  /[-+]/ contained conceal cchar=─
syntax match liotreeRootMarker /|/              conceal cchar=

" -- Conceal for dir and file --
syntax match liotreeDirIcon /[-+]\ze\%(\ [^|+]*\/['"]\{0,1}\ *>\|\ *$\)/ contained conceal cchar=
syntax match liotreeFilIcon /[-+]\ze\%(\ [^|+/]*['"]\{0,1}\ *>\|\ *$\)/  contained conceal cchar=

" --- Spaces for alignment ---
syntax match liotreeSpace / / 
         \ contained
         \ containedin=liotreeUnquotedDirname,liotreeQuotedDirname,liotreeQuotedFilename,liotreeUnquotedFilename,liotreeFilIcon,liotreeDirIcon
         \ conceal cchar=·


" --- Quoted Names ---
" Matches "Name"/ (Directory) or "Name" (File)
syntax match liotreeQuotedDirname  /["'].*\/["']\ */      contained contains=@NoSpell
syntax match liotreeQuotedFilename /["'].*[^\/]["']\ */   contained contains=@NoSpell

" --- Unquoted Names ---
syntax match liotreeUnquotedDirname  /[^-+|>\ ][^|>\ ]\+\/\s*\ze\(>\|$\)/   contained contains=@NoSpell
syntax match liotreeUnquotedFilename /[^-+|>\ ][^|>\/\ ]\+\s*\ze\(>\|$\)/   contained contains=@NoSpell

" --- Comments ---
syntax region liotreeComment start=/>/ end=/||/
   \ contained
   \ keepend
   \ contains=liotreeCommentLateralBar,@Spell
syntax match  liotreeCommentLateralBar /|/      containedin=liotreeComment conceal cchar=│
syntax match  liotreeCommentStart      />/      containedin=liotreeComment conceal cchar=▶
syntax match  liotreeCommentEnd        /||/     containedin=liotreeComment conceal cchar=█

" --- Line Definitions ---
" Structure Line: |- Filename  > Comment
syntax match liotreeStructureLine /^\s*|[-+]\+\s\+.*$/ transparent
    \ contains=liotreeLateralBar,liotreeDepthMark,liotreeDiricon,liotreeFilIcon,liotreeQuotedDirname,liotreeQuotedFilename,liotreeUnquotedDirname,liotreeUnquotedFilename,liotreeComment

" Root Line: |Filename  > Comment
syntax match liotreeRootLine /^\s*|\s[^-+ ]\+.*$/  transparent
    \ contains=liotreeRootMarker,liotreeQuotedDirname,liotreeQuotedFilename,liotreeUnquotedDirname,liotreeUnquotedFilename,liotreeComment

" --- The Error Fix ---
" Only flags if a line starts with tree structure but has a quote that never closes
syntax match liotreeError /^\s*|[-+]*\s*["'][^"']*$/

" --- Highlighting Links ---

highlight link Conceal Type

" To make the comment text italic (cursive):
highlight link liotreeLateralBar        Type
highlight link liotreeRootLine          Type
highlight link liotreeCommentLateralBar Type
highlight link liotreeStructureLine     Keyword
highlight link liotreeDepthMark         Statement
highlight link liotreeRootMarker        Type
highlight      liotreeQuotedDirname                       cterm=bold   gui=bold   guifg=#ffdd88 guibg=NONE
highlight      liotreeUnquotedDirname                     cterm=bold   gui=bold   guifg=#ffdd88 guibg=NONE
highlight      liotreeQuotedFilename                                              guifg=#ffffbb guibg=NONE
highlight      liotreeUnquotedFilename                                            guifg=#ffffbb guibg=NONE
highlight      liotreeComment                             cterm=italic gui=italic guifg=#66ddee guibg=NONE
highlight link liotreeCommentStart      Special
highlight link liotreeCommentEnd        Special
highlight      Conceal                                                            guifg=#00dd44 guibg=NONE
highlight link liotreeError             Error

let &cpoptions = s:cpo_orig
unlet s:cpo_orig

setlocal spell
