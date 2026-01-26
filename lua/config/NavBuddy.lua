local navbuddy = require("nvim-navbuddy")

lspc = vim.lsp.config

servers = { "clangd", "texlab", "intelephense", "fortls" }

for _, lsp in ipairs(servers) do
    lspc(lsp, {
        on_attach = function(client, bufnr)
            navbuddy.attach(client, bufnr)
        end
    })
end
