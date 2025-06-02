surround_conf=require("nvim-surround")
surround_conf.setup({
  delimiters = {
    pairs = {
      ["l"] = function()
        local latex_env="\\begin{" .. vim.fn.input({ prompt = "\\begin{" })
        local latex_end=string.gsub(latex_env,"\\begin{","\\end{")
        latex_end=latex_end:match("(.*}).*")
        return {
          latex_env,
          latex_end
        }
      end,
    },
  },
})
