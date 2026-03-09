-- Get if bash variable $ZELLIJ is defined equal 0
if os.getenv("ZELLIJ") == "0" then
  require('liotree.config').setup({
    executers = {
        ["Makefile"]      = "zellij ac new-pane -f --cwd __path__ -x \"80\\%\" -y \"0\" --height \"20\\%\" --width \"20\\%\" --pinned true    -- make __select__ && zellij ac toggle-floating-panes",
        ["%.plt$"]        = "zellij ac new-pane -f --cwd __path__ -x \"80\\%\" -y \"0\" --height \"20\\%\" --width \"20\\%\" --pinned true    -- gnuplot __this__&& zellij ac toggle-floating-panes",
        ["__this__dir__"] = "zellij ac new-pane -f --cwd __path__ -x \"80\\%\" -y \"0\" --height \"20\\%\" --width \"20\\%\" --pinned true -c -- bash ",
    },
    select_methods = {
        ["Makefile"] = "make_targets",
    }
  })
else
  require('liotree.config').setup({
    executers = {
        ["Makefile"]      = "cd __path__ && xfce4-terminal -e \"make __select__\""  ,
        ["%.plt$"]        = "cd __path__ && xfce4-terminal -e \"gnuplot __this__\" &> /dev/null 2>&1 &",
        ["__this__dir__"] = "cd __path__ && xfce4-terminal &> /dev/null 2>&1 &",
    },
    select_methods = {
        ["Makefile"] = "make_targets",
    }
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "liotree",
  callback = function()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end,
})

--Usercommand
vim.api.nvim_create_user_command("LiotreeSetFold", function()
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end, {})
