local M = {}

local ac = vim.api.nvim_create_autocmd
local function ag(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

ac({ "FocusGained", "BufWinEnter" }, {
    command = "checktime",
    group = ag("CheckChangeOutsideBuffer"),
    desc = "Checks if any buffer was updated outside nvim",
})

local rem_trailling_spaces_grp = ag("RemoveTraillingSpaces")
ac("FileType", {
    pattern = { "text", "c", "cpp", "cs", "java", "python", "lua" },
    callback = function() -- I'm not really sure if this is supposed way to do it
        ac("BufWritePre", {
            pattern = "<buffer>",
            callback = function()
                vim.api.nvim_command([[%s/\s\+$//e]])
            end,
            group = rem_trailling_spaces_grp,
            desc = "Delete trailing white spaces on save",
        })
    end,
    group = rem_trailling_spaces_grp,
    desc = "Checks if filetype if valid for trailling white spaces removal",
})

ac("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local row, col = mark[1], mark[2]
        if { row, col } ~= { 0, 0 } and row <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { row, 0 })
        end
    end,
    group = ag("ReturnToLastCursorPos"),
    desc = "Return to last edit position when opening files",
})

ac({ "InsertLeave", "TextChanged" }, {
    callback = function()
        local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        -- TODO: find better way to do this
        if
            vim.api.nvim_buf_get_option(0, "modifiable")
            and buf_name ~= "" -- Checks if the buf has a file attached to it
            and buf_name ~= "COMMIT_EDITMSG"
        then
            vim.cmd("silent! write")
        end
    end,
    group = ag("WriteBuffer"),
    desc = "Auto saves when leaving insert mode or when normal mode modifies text",
})

ac("FileType", {
    pattern = { "markdown", "gitcommit" },
    callback = function()
        vim.bo.textwidth = 80
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end,
    group = ag("MarkdownOptions"),
    desc = "Set some options intended for Markdown like files",
})

function M.set_statusline(statusline)
    ac({ "WinEnter", "BufEnter" }, {
        callback = function()
            vim.opt_local.statusline = statusline.active()
        end,
        group = ag("SetStatusLine"),
        desc = "Updates the statusline for the current buffer",
    })
end

-- plugins --

function M.lsp_document_highlight()
    local lsp_document_highlight_grp = ag("LspDocumentHighlight")

    -- If you want to change how fast/slow the token gets highlighted change
    -- "updatetime" on options.lua.
    ac("CursorHold", {
        pattern = "<buffer>",
        callback = vim.lsp.buf.document_highlight,
        group = lsp_document_highlight_grp,
        desc = "Highlights 'syntax tokens' inside of a document",
    })

    ac("CursorMoved", {
        pattern = "<buffer>",
        callback = vim.lsp.buf.clear_references,
        group = lsp_document_highlight_grp,
        desc = "Clear any highlights when moving the cursor",
    })
end

function M.lsp_fsharp()
    ac({ "BufNewFile", "BufRead" }, {
        pattern = { "*.fs", "*.fsx", "*.fsi" },
        command = "set filetype=fsharp",
        group = ag("SetFsharpFileType"),
    })
end

-- TODO: Create command to disable this

-- function M.nvim_tree_quit_when_lonely()
--     autocmd("BufEnter", {
--         pattern = "NvimTree_*",
--         nested = true,
--         -- This works, because I setted autowriteall to true
--         -- FIX: |quit| fails if the file can't be saved by autowriteall ( e.g [No Name] buffers )
--         callback = function()
--             if vim.fn.winnr("$") == 1 then
--                 vim.cmd("q")
--             end
--         end,
--         group = augroup("NvimTreeQuitWhenLonely"),
--         desc = "Quit neovim when NvimTree is the only window and tab opened",
--     })
-- end

function M.toggleterm_clear()
    ac({ "TermOpen", "BufEnter" }, {
        pattern = "term://*toggleterm#*",
        callback = function()
            if vim.o.hlsearch then
                vim.o.hlsearch = false
            end
        end,
        group = ag("CleanTerminal"),
        desc = "Disables search highlight",
    })
end

return M
