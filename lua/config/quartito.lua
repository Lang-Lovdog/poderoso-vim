local g = vim.g

require('quarto').setup({
  lspFeatures = {
    enabled = true,
    chunks = "curly",
    languages = { "python", "html", " r" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
  enabled = true,
  default_method = "molten",
  ft_runners = { python = "molten" },
  never_run = { "yaml" },
 },
})

require('jupytext').setup({
    custom_language_formatting = {
    python = {
      extension = "qmd",
      style = "quarto",
      force_ft = "quarto", -- you can set whatever filetype you want here
    },
  }
})

g.molten_auto_image_popup = true
g.molten_image_provider = "image.nvim"
g.molten_output_win_max_height = 30
g.molten_output_virt_lines = true
g.molten_virt_text_output = true
g.molten_auto_open_output = false
g.molten_save_path = vim.fn.stdpath("data") .. "/molten"

local wk = require("which-key")
local runner = require("quarto.runner")
local quarto = require("quarto")

wk.add({
 { "<leader>0q", group = "jupyter", icon = { icon = "", color = "blue" } },

 { "<leader>0qA", runner.run_all, desc = "All Cells" },
 { "<leader>0qa", runner.run_above, desc = "Cell and Above" },
 { "<leader>0qc", runner.run_cell, desc = "Cell" },
 { "<leader>0ql", runner.run_line, desc = "Line" },

 { "<leader>0qp", quarto.quartoPreview, desc = "Open Preview" },
 { "<leader>0qq", quarto.quartoClosePreview, desc = "Close Preview" },

 { "<leader>0qd", ":MoltenLoad<cr>", desc = "Load Molten State" },
 { "<leader>0qc", create_kernel_from_conda, desc = "Create Kernel" },
 { "<leader>0qs", ":MoltenSave<cr>", desc = "Save Molten State" },
 { "<leader>0qi", ":MoltenInit<cr>", desc = "Init Molten" },
 { "<leader>0qD", ":MoltenDeinit<cr>", desc = "Deinit Molten" },
 { "<leader>0qI", ":MoltenImagePopup<cr>", desc = "Show Image" },
 { "<leader>0qo", ":MoltenShowOutput<cr>", desc = "Show Output" },
 { "<leader>0qv", "<cmd>VenvSelect<cr>", desc = "Select LSP Env" },
})

require("venv-selector").setup({})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.qmd",
  callback = function()
    vim.bo.filetype = "quarto"
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.qmd",
  callback = function()
    vim.bo.filetype = "quarto"
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.qmd",
  callback = function()
    vim.opt.conceallevel = 1
  end,
})
