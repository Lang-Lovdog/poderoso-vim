" 1. Set the fold method to expression
setlocal foldmethod=expr
setlocal foldexpr=LioTreeFoldLevel(v:lnum)

" 2. Define the folding logic
function! LioTreeFoldLevel(lnum)
    let line = getline(a:lnum)

    " If the line has depth markers like |-- or |---
    if line =~ '^\s*|[-+]\+'
        " Count the number of - or + characters to determine depth
        return strlen(matchstr(line, '[-+]\+'))
    endif

    " Root level
    if line =~ '^\s*|[^-+ ]'
        return 1
    endif

    " Keep previous fold level for comment lines starting with |
    if line =~ '^\s*|\s\{2,}'
        return '='
    endif

    return 0
endfunction
