syntax on
set nowrap
set number
set expandtab
"set autoindent
set smartindent
set softtabstop=2
set tabstop=2
set shiftwidth=2
set showtabline=2
set cursorline
set cursorcolumn
set termguicolors
set spell
set spelllang=en,ru,es,fr,de,pt,it

set foldmethod=syntax

set guicursor=n:block 
set guicursor=i:block 
"let g:tex_flavor='latex'
let g:tex_flavor='xelatex'
let g:python3_host_prog='/usr/bin/python3.11'


":command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
":command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78
so /home/lang_lovdog/.config/nvim/UltiSnips/plugins.vim
so /home/lang_lovdog/.config/nvim/UltiSnips/plugin-config.vim
so /home/lang_lovdog/.config/nvim/UltiSnips/maps.vim
so /home/lang_lovdog/.config/nvim/UltiSnips/emmet.vim
so /home/lang_lovdog/.config/nvim/my_plugs/nerd-dict
so /home/lang_lovdog/.config/nvim/my_plugs/cwd_to_bash_below
lua require('config/treesitter')
lua require('config/colorizer_conf')
lua require('config/mason-conf')
lua require('config/lspconfig-conf')
lua require('config/gitsigns_conf')
lua require('config/lint-conf')
lua require('config/nvimcmp_conf')
"lua require('config/timeTracker')
lua require('config/sessions')
lua require('config/svgprev')
lua require('config/livepreview')
lua require('config/bufferFoldRules')
lua require('config/jsonfly')
"lua require('config/csvtools_conf')
lua require('config/surround')
"lua require('config/rainbowcsv_conf')
lua require('config/lovdog_configs')
lua require('config/neworg')
"----- SNIP -----
" Octave syntax
augroup filetypedetect
  au! BufRead,BufNewFile *.oct set filetype=octave
augroup END
" Use keywords from Octave syntax language file for autocomplete
if has("autocmd") && exists("+omnifunc")
   autocmd Filetype octave
   \ if &omnifunc == "" |
   \ setlocal omnifunc=syntaxcomplete#Complete |
   \ endif
endif 
"----- SNIP -----
"colorscheme monochrome 
"colorscheme lunaperche
"colorscheme peachpuff
"colorscheme elflord
colorscheme lang_quiet

au BufEnter *.puml     set filetype=plantuml "plantuml
au BufEnter *.plantuml set filetype=plantuml "plantuml
au BufEnter *.plntuml  set filetype=plantuml "plantuml

"au BufEnter *.puml     set filetype=dot "plantuml
"au BufEnter *.plantuml set filetype=dot "plantuml
"au BufEnter *.plntuml  set filetype=dot "plantuml

"hi Conceal guifg=#ff00ff guibg=#000000 gui=NONE cterm=NONE
set conceallevel=2
set concealcursor=n
let fortran_linter = -1
