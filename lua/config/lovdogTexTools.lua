--function RenderMathAtCursor()
--    -- 1. Get the current line (or you could use a visual selection)
--    local raw_latex = vim.api.nvim_get_current_line()
--    
--    -- 2. Escape backslashes for the shell/python
--    local escaped_latex = raw_latex:gsub("\\", "\\\\")
--
--    -- 3. The Python script to parse and pretty-print
--    local python_cmd = string.format([[
--python3 -c "
--import sympy
--from sympy.parsing.latex import parse_latex
--from sympy import pretty
--
--try:
--    # Parse the LaTeX string into a SymPy expression
--    expr = parse_latex(r'%s', backend='lark')
--    # Output the UTF-8 pretty-print version
--    print(pretty(expr, use_unicode=True))
--except Exception as e:
--    print(f'Error parsing LaTeX: {e}')
--"
--]], escaped_latex)
--
--    -- 4. Run it and capture the output
--    local output = vim.fn.systemlist(python_cmd)
--
--    -- 5. Show in a floating window (The "Throbber" style UI)
--    local buf = vim.api.nvim_create_buf(false, true)
--    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
--    
--    local width = 0
--    for _, l in ipairs(output) do width = math.max(width, #l) end
--    
--    vim.api.nvim_open_win(buf, true, {
--        relative = 'cursor',
--        row = 1,
--        col = 0,
--        width = math.min(width + 2, 80),
--        height = #output,
--        style = 'minimal',
--        border = 'rounded'
--    })
--end
--
--vim.keymap.set('n', '<leader>mp', RenderMathAtCursor, { desc = 'Math Preview (SymPy)' })


local math_preview_enabled = false

function GetMathUnderCursor()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- 1. Check for inline math: \( ... \) or $ ... $
    local math_expr = nil
    local s, e = 0, 0
    while true do
        s, e = line:find("\\%((.-)\\%)+", e + 1)
        if not s then break end
        if col >= s and col <= e then return line:sub(s + 2, e - 2) end
    end
    
    s, e = 0, 0
    while true do
        s, e = line:find("%$([^%$]+)%$", e + 1)
        if not s then break end
        if col >= s and col <= e then return line:sub(s + 1, e - 1) end
    end

    -- 2. Check for Environments (equation, align, etc.)
    -- We look upwards and downwards from the cursor
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local curr_row = vim.api.nvim_win_get_cursor(0)[1]
    local start_row, end_row = nil, nil

    for i = curr_row, 1, -1 do
        if lines[i]:find("\\begin{") then start_row = i break end
    end
    for i = curr_row, #lines do
        if lines[i]:find("\\end{") then end_row = i break end
    end

    if start_row and end_row then
        local content = table.concat(lines, "\n", start_row + 1, end_row - 1)
        -- Strip labels or comments
        return content:gsub("\\label{[^}]+}", "")
    end

    return nil
end


local preview_win = nil

function ShowMathPreview()
    if not math_preview_enabled then return end
    
    local expr = GetMathUnderCursor()
    if not expr or expr == "" then
        -- Close window logic...
        return
    end

    -- No more escaping nightmares! 
    -- Just use expand to get the full path to your script
    local script_path = vim.fn.expand("~/.config/nvim/my_plugs/synpy_texrender.py")
    local output = vim.fn.systemlist({ "python3", script_path, expr })

    -- Window logic
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
    end

    preview_win = vim.api.nvim_open_win(buf, false, {
        relative = 'cursor', row = 1, col = 0,
        width = 50, height = #output,
        style = 'minimal', border = 'single', focusable = false
    })
end

-- Toggle functionality
vim.keymap.set('n', '<leader>mp', function()
    math_preview_enabled = not math_preview_enabled
    
    -- If we just turned it off, kill the window immediately
    if not math_preview_enabled then
        if preview_win and vim.api.nvim_win_is_valid(preview_win) then
            vim.api.nvim_win_close(preview_win, true)
            preview_win = nil
        end
        print("Math Preview: OFF")
    else
        print("Math Preview: ON")
    end
end, { desc = "Toggle SymPy Math Preview" })

-- The "Pulse": Check every time the cursor stops moving
vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    pattern = "*.tex",
    callback = function()
        ShowMathPreview()
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*.tex",
    callback = function()
        if preview_win and vim.api.nvim_win_is_valid(preview_win) then
            vim.api.nvim_win_close(preview_win, true)
            preview_win = nil
        end
    end,
})

-- Performance: How long to wait (in milliseconds) before rendering
vim.opt.updatetime = 300

