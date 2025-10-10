require('venv-selector').setup({
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>'},
    { '<leader>vc', '<cmd>VenvSelectCached<cr>'},
  }
});
