" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

"Instant config
let g:instant_username = "lovdog"

"Bracey_Config
let g:bracey_browser_command="midori"
let g:bracey_server_port=3000
let g:bracey_server_path="http://localhost"


"Configurando el buffer de copiado
let g:clipboard={
  \  'name':'xclip-xfce4-clipman',
  \  'copy':{
  \    '+': 'xclip -selection clipboard',
  \    '*': 'xclip -selection clipboard',
  \  },
  \  'paste':{
  \    '+': 'xclip -selection clipboard -o',
  \    '*': 'xclip -selection clipboard -o',
  \  },
  \  'cache_enabled': 1,
  \}


""" AirLatex Overleaf
" your login-name
"let g:AirLatexUsername='cookies:overleaf_session2=s%3ASAsejv5wNH_f16GQBJ0mmVHQNb0zMPZP.kWIcCDirPUdPYFgefY%2Ft9dCE%2B9%2Flm6Y6Wv5GPAok3Kc'

let g:AirLatexCookieDB="~/.mozilla/firefox/cuzie91k.default-default/cookies.sqlite"

" Viewer options: One may configure the viewer either by specifying a built-in
if empty(v:servername) && exists('*remote_startserver')
  call remote_startserver('VIM')
endif
let g:vimtex_syntax_enabled = 0
let g:vimtex_view_general_viewer = 'sioyek'
let g:vimtex_view_method = 'sioyek'
let g:vimtex_compiler_progname = "'/usr/bin/nvim'"
let g:vimtex_view_sioyek_options = '--reuse-window'
let g:vimtex_view_enabled = 0
" viewer method:
" Or with a generic interface:
let g:vimtex_compiler_latexmk = {
  \ 'executable': 'latexmk',
  \ 'options': [
  \   '-shell-escape',
  \   '-file-line-error',
  \   '-synctex=1',
  \   '-interaction=nonstopmode',
  \   '-bibtex',
  \ ],
  \}

let g:fzf_layout={'down': '30%'}

"Tree Sitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight={
    enable=true,
  },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.matlab={
  filetype="octave",
}
EOF

" NvimTree
lua << EOF
require("nvim-tree").setup{
  update_cwd = true,
  renderer={
    highlight_modified = "none",
    indent_width = 2,
    icons={
      webdev_colors=false,
    },
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
  },
}
EOF


lua << EOF
  require("oil").setup()
EOF


let fortran_linter = -1
let g:fprettify_options = "--silent"

let g:rainbow_delimiters = {
    \ 'strategy':{
      \ '': rainbow_delimiters#strategy.global,
      \ 'vim': rainbow_delimiters#strategy.local,
    \ },
    \ 'query':{
      \'': 'rainbow-delimiters',
    \ },
    \ 'highlight':[
      \ 'RainbowDelimiterYellow',
      \ 'RainbowDelimiterOrange',
      \ 'RainbowDelimiterCyan',
      \ 'RainbowDelimiterViolet'
    \ ],
\ }


lua << EOF
  -- Guardar la dirección del directorio actual en la variable  
  -- g:virtualenv_directory, cada vez que haya  un cambio de directorio
  -- con el comando :cd
  vim.api.nvim_create_autocmd('DirChanged', {
    callback = function()
      vim.g.virtualenv_directory = vim.fn.getcwd()
    end
  })
EOF
