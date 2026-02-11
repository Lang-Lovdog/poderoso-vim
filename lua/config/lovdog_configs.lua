vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_user_command("View",
function()
  local file = vim.fn.expand("%")
  -- Verify filetype
  if string.find(file, ".tex") ~= nil then
    os.execute(vim.g.vimtex_view_method .. " " .. file:gsub(".tex", ".pdf" .. " > /dev/null 2>&1"))
  end
end
, {}
);

-- Define a function that creates an autocommand
-- that'll run TexlabForward on CursorMove for *.tex files
vim.cmd("let g:texforward_enabled=0")
function texforward(enabled)
  if enabled then -- Create the autocommand
    -- Create flag for TexForward enabled
    vim.g["texforward_enabled"]=1
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      pattern = { "*.tex" },
      callback = function()
        vim.api.nvim_command("TexlabForward")
      end,
    })
    return
  end
  -- Delete the autocommand, if it exists
  vim.api.nvim_del_autocmds({ event = "CursorMoved", pattern = "*.tex" })
end

-- User command that'll toggle the autocommand
vim.api.nvim_create_user_command("TexForward", function()
  if vim.g["texforward_enabled"]==0 then
    texforward(true)
    print("Texlab cursor following forward search enabled")
    return
  end
  texforward(false)
  print("Texlab cursor following forward search disabled")
  return
end, {})


-- Define a command for creating a new tex file with the current date
vim.api.nvim_create_user_command("NewTex", function(args)
  local texroot
  local name
  local mainfile
  -- Date format: Viernes-DD-MM-YYYY
  local date = os.date("%a-%d-%m-%Y")
  -- If there's a file .project in the current directory
  -- read the name of the project from it
  if vim.fn.filereadable(".project") == 1 then
    local project = io.open(".project", "r")
    -- Search for project name, texroot keywords
    for line in project:lines() do
      if string.find(line, "name") ~= nil then
        name = date .. "-" .. string.match(line, "name%s*:%s*\"(.*)\"")
      end
      if string.find(line, "texroot") ~= nil then
        mainfile =  string.match(line, "texroot%s*:%s*\"(.*)\"")
        texroot = "%!TEX root = " .. mainfile
      end
    end
  elseif args.args ~= nil then
    name = args.args
    name = date .. "-" .. name .. ".tex"
  end
  local inputln = "\\input{" .. name .. "}"
  name = name .. ".tex"
  if texroot ~= nil then
    -- Add texroot as first line
    if vim.fn.filereadable(name) == 0 then
      local sasa = io.open(name, "w")
      sasa:write(texroot .. "\n")
      io.close(sasa)
    end
    -- Add this new file to the main project file
    -- before the \end{document} line
    -- Cache file
    local mainfilenew=mainfile .. ".new"
    local project = io.open(mainfile, "r")
    local sasa1 = io.open(mainfilenew, "w")
    local bandera = true
    for line in project:lines() do
      if string.find(line, inputln, 1, true) ~= nil then
        sasa1:write(line .. "\n")
        bandera = false
      elseif string.find(line, "\\end{document}") ~= nil and bandera then
        sasa1:write(inputln .. "\n")
        sasa1:write(line .. "\n")
      else
        sasa1:write(line .. "\n")
      end
    end
    io.close(project)
    io.close(sasa1)
    os.execute("cat " .. mainfilenew .. " > " .. mainfile)
    os.execute("rm " .. mainfilenew)
  end
  vim.api.nvim_command("edit " .. name)
end, {})

-- Function to add current file to project file (LaTeX input method)
function AddFileToProjectTex()
  -- Get root from current buffer magic command
  -- %!TEX root = main.tex
  local texroot = string.match(vim.api.nvim_buf_get_lines(0, 0, 1, false)[1], "%!TEX root = (.*)")
  if texroot == nil then
    if vim.fn.filereadable(".project") == 0 then
      local pf = io.open(".project", "r")
      for line in pf:lines() do
        if string.find(line, "texroot") ~= nil then
          texroot = string.match(line, "texroot%s*:%s*\"(.*)\"")
        end
      end
      io.close(pf)
    end
  end
  if texroot == nil then
    print("No .project file nor %!TEX root found")
    return
  end
  -- Get this file basename remove full path
  local thisfile = vim.api.nvim_buf_get_name(0)
  thisfile = string.match(thisfile, ".*/(.*).tex")
  if thisfile == texroot then
    print("File already in project")
    return
  end
  local inputln = "\\input{" .. thisfile .. "}"
  local sasa = io.open(texroot .. ".new", "w+")
  local project = io.open(texroot, "r")
  local bandera = true
  for line in project:lines() do
    if string.find(line, inputln, 1, true) ~= nil then
      sasa:write(line .. "\n")
      bandera = false
    elseif string.find(line, "\\end{document}") ~= nil and bandera then
      sasa:write(inputln .. "\n")
      sasa:write(line .. "\n")
    else
      sasa:write(line .. "\n")
    end
  end
  io.close(sasa)
  io.close(project)
  os.execute("cat " .. texroot .. ".new > " .. texroot)
  os.execute("rm " .. texroot .. ".new")
  print("File added to project")
end

-- Function to remove current file from project file (LaTeX input method)
function RemoveFileFromProjectTex()
  -- Get root from current buffer magic command
  -- %!TEX root = main.tex
  local texroot = string.match(vim.api.nvim_buf_get_lines(0, 0, 1, false)[1], "%!TEX root = (.*)")
  if texroot == nil and vim.fn.filereadable(".project") == 0 then
    print("No .project file nor %!TEX root found")
    return
  end
  -- Get this file basename remove full path
  local thisfile = vim.api.nvim_buf_get_name(0)
  thisfile = string.match(thisfile, ".*/(.*).tex")
  local inputln = "\\input{" .. thisfile .. "}"
  local sasa = io.open(texroot .. ".new", "w+")
  local project = io.open(texroot, "r")
  for line in project:lines() do
    if string.find(line, inputln, 1, true) == nil then
      sasa:write(line .. "\n")
    end
  end
  io.close(sasa)
  io.close(project)
  os.execute("cat " .. texroot .. ".new > " .. texroot)
  os.execute("rm " .. texroot .. ".new")
  print("File removed from project")
end

vim.api.nvim_create_user_command("UnlinkMe", function()
  -- Check if current buffer is a tex file
  if string.find(vim.api.nvim_buf_get_name(0), ".tex") ~= nil then
    RemoveFileFromProjectTex()
    return
  end
end, {})

vim.api.nvim_create_user_command("LinkMe", function()
  -- Check if current buffer is a tex file
  if string.find(vim.api.nvim_buf_get_name(0), ".tex") ~= nil then
    AddFileToProjectTex()
    return
  end
end, {})

-- Spellchecker config
-- Set configs via vim api
-- hi clear SpellBad
vim.api.nvim_set_hl(0, "SpellBad", {})
-- " Set style for gVim
vim.api.nvim_set_hl(0, "SpellBad", {
  underline = true,
-- hi SpellBad gui=undercurl
  gui = "undercurl",
-- hi SpellBad cterm=underline
  cterm = "underline"
})
