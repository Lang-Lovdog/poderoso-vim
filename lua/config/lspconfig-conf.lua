--lspc = require("lspconfig")
lspc = vim.lsp.config
lspe = vim.lsp.enable

lspc('intelephense', {
  --root_dir = require('lspconfig.util').root_pattern('composer.json','.git','index.php','index.html')*/
  root_dir = require('lspconfig.util').root_pattern('index.php')
})

lspe('clangd')

lspe('fortls')

require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
})

lspc('texlab',{
    filetypes = { 'tex', 'bib', 'plaintex' },
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        texlab = {
            -- if you want to use chktex
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            },
            chktex = { onOpenAndSave = true },
            formaterLineLength = 80,
            forwardSearch = {
              executable = "sioyek",
              args = {
                  "--reuse-window",
                  "--execute-command",
                  "turn_on_synctex",
                  "--inverse-search",
                  string.format("bash -c %s", string.format(
                      "\"nvim --headless --noplugin --server %s --remote \"%s\" && nvim --headless --noplugin --server %s --remote-send \"gg%sjk0%slh\"\"",
                      vim.v.servername,
                      "%%1",
                      vim.v.servername,
                      "%%2",
                      "%%3"  
                  )),
                  "--forward-search-file",
                  "%f",
                  "--forward-search-line",
                  "%l",
                  "--forward-search-column",
                  "%p",
              },
            },
        },
    },
})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


local on_attach = function(client, bufnr)

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end
