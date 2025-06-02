require("telescope").load_extension("jsonfly")
require("telescope").setup({
    extensions={
      jsonfly = {
        ft={"json", "jsonc", "yaml", "xml"},
      }
    }
})
