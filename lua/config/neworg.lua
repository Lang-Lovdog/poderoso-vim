local JournalPath = "$HOME/Documentos/Journal/"

require("neorg").setup {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.highlights"] = {},
    ["core.latex.renderer"] = {
      config={
        conceal = true,
        engine = "xelatex",
        debounce_ms = 350,
        dpi = 300,
        renderer = "core.integrations.image",
      },
    },
    ["core.integrations.nvim-cmp"] = {},
    ["core.completion"] = { config = { engine = "nvim-cmp" } },
    ["core.integrations.treesitter"] = {
      config ={
        norg = {
          parser_configs ={
            url="https://github.com/nvim-neorg/tree-sitter-norg",
          },
        },
        norg_meta = {
          parser_configs = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
          },
        },
      },
    },
    ["core.dirman"] = {
      config = {
        workspaces = {
          hataraki = JournalPath .. "HatarakiNotes",
          personal = JournalPath .. "PersonalJournal",
          MiMundoSciFi = JournalPath .. "MiMundoSciFi",
        },
        default_workspace = "hataraki",
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
  -- Get commit message
  local message = vim.fn.input("Commit message: ")
  -- Commit and push
  print(vim.fn.system("cd " .. JournalPath .. " && git pull origin historia"))
end, {})


vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.norg",
  callback = function()
    vim.bo.filetype = "norg"
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.norg",
  callback = function()
    vim.bo.filetype = "norg"
  end,
})
