local JournalPath = "$HOME/Documentos/Journal/"

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.norg",
  callback = function()
    vim.bo.filetype = "norg"
    -- vim.treesitter.start()
    -- This forces the legacy syntax engine to stay awake for the injections
    -- Put colorcolumn at 64 and 128
    vim.opt.colorcolumn = "64,128"
    vim.opt.wrap = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "norg",
    callback = function()
        -- This ensures that inside Neorg, the spellchecker doesn't 
        -- overwrite the foreground color (fg) of the text.
        vim.api.nvim_set_hl(0, "SpellBad", { fg = "NONE", sp = "#ff5555", undercurl = true, force = true })
        vim.api.nvim_set_hl(0, "SpellCap", { fg = "NONE", sp = "#5555ff", undercurl = true, force = true })
        
        -- We also force Neorg's own spell capture to be transparent
        vim.api.nvim_set_hl(0, "@spell.norg", { fg = "NONE", force = true })
    end,
})

require("neorg").setup {
--  lazy_loading = false,
  load = {
    ["core.syntax"] = {},
    ["core.itero"] = {},
    ["core.export"] = {},  
    ["core.export.markdown"] = {  
        config = {  
            extensions = "all",
            extension = "md",  
        }  
    },
    ["core.defaults"] = {},
    ["core.keybinds"] = {},
    ["core.autocommands"] = {},
    ["core.concealer"] = {
      config = {
        init_open = true, 
      }
    },
    ["core.neorgcmd"] = {},
    ["core.highlights"] = {},
    ["core.completion"] = { config = { engine = "nvim-cmp" } },
    ["core.latex.renderer"] = {},
    ["core.integrations.treesitter"] = {},
    ["core.integrations.image"] = {},
    ["core.integrations.nvim-cmp"] = {},
    ["core.integrations.otter"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          hataraki      = JournalPath .. "HatarakiNotes",
          personal      = JournalPath .. "PersonalJournal",
          MiMundoSciFi  = JournalPath .. "MiMundoSciFi",
          WulfusCanidae = JournalPath .. "WulfusCanidae",
          LovoFriki     = JournalPath .. "LovoFriki",
        },
      },
    },
  },
}

-- Command to commit and push Journal files
vim.api.nvim_create_user_command("JournalCommit", function(args)
  -- Get commit message
  local message = args.fargs[1]
  -- For sourrounding quotes
  if string.find(message, "\"") == nil then
    message = "\"" .. message .. "\""
  end
  -- Commit and push
  vim.cmd("!(cd " .. JournalPath .. " && git add . && git commit -m '" .. message .. "' && git push origin historia)")
end, {})

-- Command to commit and push Journal files
vim.api.nvim_create_user_command("JournalUpdate", function()
  -- Commit and push
  vim.cmd("!(cd " .. JournalPath .. " && git pull origin historia)")
end, {})


vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.quarto",
  callback = function()
    vim.bo.conceallevel = 1
  end,
})
