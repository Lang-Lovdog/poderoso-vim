local ns_id = vim.api.nvim_create_namespace('ParaStats')

local function get_para_stats()
    -- 1. Only run for prose/academic types
    local ft = vim.bo.filetype
    if not (ft == 'tex' or ft == 'markdown' or ft == 'text') then 
        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        return 
    end

    -- 2. Find paragraph boundaries
    local cursor = vim.api.nvim_win_get_cursor(0)
    local last_line = vim.api.nvim_buf_line_count(0)
    
    -- Use searchpos to find the next/previous empty lines (paragraph bounds)
    local start_line = vim.fn.searchpos('^\\s*$', 'bnW')[1]
    local end_line = vim.fn.searchpos('^\\s*$', 'nW')[1]
    if end_line == 0 then end_line = last_line + 1 end

    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line - 1, false)
    local content = table.concat(lines, " ")

    -- 3. Clean content for LaTeX (Optional but helpful for Thesis)
    -- Removes backslashed commands like \cite{...} or \textbf{...}
    if ft == 'tex' then
        content = content:gsub("\\%a+{[^}]*}", ""):gsub("\\%a+", "")
    end

    -- 4. Calculate Stats
    local _, word_count = content:gsub("%S+", "")
    local char_count = #content

    -- 5. Render Virtual Text
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    if word_count > 0 then
        local display = string.format("  󰌨 %d w | %d c", word_count, char_count)
        -- Place it at the end of the current paragraph
        vim.api.nvim_buf_set_extmark(0, ns_id, math.max(0, end_line - 2), 0, {
            virt_text = {{ display, "Comment" }},
            virt_text_pos = 'eol',
        })
    end
end

-- Update on movement or text change
vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("ParaStatsGroup", { clear = true }),
    callback = get_para_stats,
})

-- Speed up the "CursorHold" trigger
vim.opt.updatetime = 300
