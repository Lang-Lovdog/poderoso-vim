local JournalPath = "$HOME/Documentos/Journal/"

-- Ensure filetype is set correctly  
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {  
    pattern = "*.norg",  
    callback = function()  
        vim.bo.filetype = "norg"  
        vim.opt.conceallevel = 2
    end,  
})

require("neorg").setup {
--  lazy_loading = false,
  load = {
    ["core.export"] = {},  
    ["core.export.markdown"] = {  
        config = {  
            extensions = "all",  -- or specify individual extensions  
            extension = "md",  
        }  
    },
    ["core.defaults"] = {},
    ["core.keybinds"] = {},
    ["core.autocommands"] = {},
    ["core.concealer"] = {},
    ["core.neorgcmd"] = {},
    ["core.highlights"] = {},
    ["core.completion"] = { config = { engine = "nvim-cmp" } },
    ["core.latex.renderer"] = {},
    --["core.latex.renderer"] = {
    --  config={
    --    conceal = true,
    --    engine = "xelatex",
    --    debounce_ms = 350,
    --    dpi = 300,
    --    renderer = "core.integrations.image",
    --  },
    --},
    ["core.integrations.treesitter"] = {},
    ["core.integrations.image"] = {},
    ["core.integrations.nvim-cmp"] = {},
    ["core.integrations.otter"] = {},
    --["core.integrations.treesitter"] = {
    --  config ={
    --    norg = {
    --      parser_configs ={
    --        url="https://github.com/nvim-neorg/tree-sitter-norg",
    --      },
    --    },
    --    norg_meta = {
    --      parser_configs = {
    --        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    --      },
    --    },
    --  },
    --},
    ["core.dirman"] = {
      config = {
        workspaces = {
          hataraki = JournalPath .. "HatarakiNotes",
          personal = JournalPath .. "PersonalJournal",
          MiMundoSciFi = JournalPath .. "MiMundoSciFi",
        },
      },
    },
  },
}

-- Command to commit and push Journal files
vim.api.nvim_create_user_command("JournalCommit", function()
  -- Get commit message
  local message = vim.fn.input("Commit message: ")
  -- Commit and push
  print(vim.fn.system("cd " .. JournalPath .. " && git add . && git commit -m '" .. message .. "' && git push origin historia "))
end, {})

-- Command to commit and push Journal files
vim.api.nvim_create_user_command("JournalUpdate", function()
  -- Commit and push
  print(vim.fn.system("cd " .. JournalPath .. " && git pull origin historia"))
end, {})


vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.quarto",
  callback = function()
    vim.bo.conceallevel = 1
  end,
})
