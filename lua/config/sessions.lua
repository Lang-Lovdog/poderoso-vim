require("auto-session").setup {
  suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
  session_lens = {
    picker = telescope, -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also manually choose one. Falls back to vim.ui.select
    mappings = {
      -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
      delete_session    = { "i", "<C-d>" },
      alternate_session = { "i", "<C-s>" },
      copy_session      = { "i", "<C-y>" },
    },
  },
}

-- Autocommand, at start if theres no file opened, start search
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.api.nvim_command("AutoSession search")
    end
  end,
})
