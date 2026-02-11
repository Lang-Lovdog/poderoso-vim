-- One‑time setup: copies queries and installs parser
vim.api.nvim_create_user_command('LioTreeInstall', function()
  local src = vim.fn.stdpath('config') .. '/TreeSitter-Lab/liotree/queries'
  local dst = vim.fn.stdpath('config') .. '/queries/liotree'

  -- Copy queries (overwrites existing)
  vim.fn.mkdir(dst, 'p')
  vim.fn.system({ 'cp', '-r', src .. '/.', dst .. '/' })

  -- Register parser (relative path)
  require('nvim-treesitter.parsers').get_parser_configs().liotree = {
    install_info = {
      url = vim.fn.stdpath('config') .. '/TreeSitter-Lab/liotree',
      files = { 'src/parser.c' },
      generate_requires_npm = false,
      requires_generate_from_grammar = false, -- if src/parser.c is committed
    },
    filetype = 'liotree',
  }

  -- Install/update parser
  vim.cmd('TSInstallSync liotree')
  print('✅ LioTree installed')
end, {})

-- For Lovdog Tree syntax
-- " Match filename extension to syntax filetype
-- autocmd BufNewFile,BufRead *.liotree set filetype=liotree

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.liotree",
  command = "set filetype=liotree",
})
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.liotree",
  command = "set filetype=liotree",
})

-- Lovdog Tree Format
-- 1. First, register the filetype for .liotree files
vim.filetype.add({
  extension = {
    liotree = "liotree",
  },
})

