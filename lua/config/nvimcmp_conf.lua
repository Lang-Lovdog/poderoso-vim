local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  completion={
    completeopt = "menu,menuone,noselect",
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.scroll_docs(-1),
    ["<C-n>"] = cmp.mapping.scroll_docs(1),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Right>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "neorg" },
    { name = "vimtex" },
    { name = 'render-markdown' },
    { name = "ultisnips" },
    { name = "luasnip" },
    { name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
    { name = "path" },
    { name = "pandoc_references" },
    { name = "cmdline" },
  },
})
