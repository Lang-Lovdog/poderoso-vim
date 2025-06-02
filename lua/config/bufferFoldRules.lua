vim.api.nvim_create_autocmd({"BufEnter"},{
    callback = function()
      if require("nvim-treesitter.parsers").has_parser() then
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      else
        vim.opt.foldmethod = "syntax"
      end
    end,
})
