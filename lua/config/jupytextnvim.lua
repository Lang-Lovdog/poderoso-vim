require("jupytext").setup({
  style = "quarto",       -- Quarto-style cell markers (`# |`)
  output_extension = "qmd", -- Convert to Quarto markdown (optional)
  custom_language_formatting = {
    python = { extension = "qmd", force_ft = "markdown" },  -- Treat as Quarto
  },
})
