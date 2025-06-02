require("mason").setup({
  ensure_installed = { 
    "mypy",
    "ruff", 
    "clangd", 
    "texlab", 
    "css-lsp", 
    "html-lsp", 
    "biome", 
    "intelephense",
    "fortls"
  },
})
require("mason-lspconfig").setup({
  ensure_installed = { 
    "ruff", 
    "clangd", 
    "texlab", 
    "html", 
    "biome",
    "intelephense",
    "fortls"
  },
})
