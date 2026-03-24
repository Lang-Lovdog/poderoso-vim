require('overleaf').setup({
  cookie = 'overleaf_session2=s%3A38hWh1dG9VKxX29UHjufLomGHaU78_Dx.LE%2FZa7yuKcAih3JbEGPqQjC8ElKzjemmmPc%2FAIS%2FTJM',
  sync_dir = '~/overleaf',
  log_level = 'error',
})


-- Throbber
-- 1. Define the Spinner Logic
local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
local frame = 1

function _G.overleaf_spinner()
  -- Only spin if we are in a tex file and the overleaf plugin is loaded
  if vim.bo.filetype == 'tex' then
    frame = (frame % #spinner_frames) + 1
    return spinner_frames[frame] .. " Sync"
  end
  return ""
end

-- 2. Inject into Airline (Vimscript Bridge)
-- This puts it in section 'z' (where line/column usually are)
vim.cmd([[
  function! AirlineOverleafStatus()
    return v:lua.overleaf_spinner()
  endfunction

  " Add the function to airline's sections
  let g:airline_section_z = airline#section#create(['%p%% ', 'ln %l/%L', 'col %c ', ' ', 'AirlineOverleafStatus'])
]])
