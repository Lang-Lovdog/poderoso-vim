-- Attaches to every FileType mode
require 'colorizer'.setup()

-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
require 'colorizer'.setup {
  'css';
  'javascript';
  'lua';
  'python';
  'fortran';
  'cmake';
  'markdown';
  'vim';
  'tex';
  'latex';
  html = {
    mode = 'foreground';
  }
}
