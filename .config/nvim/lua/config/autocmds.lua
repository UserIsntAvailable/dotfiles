local M = {}

local opts = { clear = true }

vim.api.nvim_create_autocmd({ "FocusGained", "BufWinEnter" }, {
    command = "checktime",
    group = vim.api.nvim_create_augroup("CheckChangeOutsideBuffer", opts),
    desc = "Checks if any buffer was updated outside nvim",
})

local rem_trailling_spaces_grp = vim.api.nvim_create_augroup("RemoveTraillingSpaces", opts)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "c", "cpp", "cs", "java", "python", "lua" },
    callback = function() -- Im not really sure if this is the way to do it
        vim.api.nvim_create_autocmd("BufWritePre", {
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

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local line = vim.fn.line
        if line([['"]]) > 1 and line([['"]]) <= line("$") then
            vim.api.nvim_command([[normal! g'"]])
        end
    end,
    group = vim.api.nvim_create_augroup("ReturnToLastCursorPos", opts),
    desc = "Return to last edit position when opening files",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
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
    group = vim.api.nvim_create_augroup("WriteBuffer", opts),
    desc = "Auto saves when leaving insert mode or when normal mode modifies text",
})

-- plugins --

function M.lsp_document_highlight()
    local lsp_document_highlight_grp = vim.api.nvim_create_augroup("LspDocumentHighlight", opts)

    --[[
        If you want to change how fast/slow the token gets highlighted
        change "updatetime" on options.lua
    --]]
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "<buffer>",
        callback = vim.lsp.buf.document_highlight,
        group = lsp_document_highlight_grp,
        desc = "Highlights 'syntax tokens' inside of a document",
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        pattern = "<buffer>",
        callback = vim.lsp.buf.clear_references,
        group = lsp_document_highlight_grp,
        desc = "Clear any highlights when moving the cursor",
    })
end

function M.nvim_tree_quit_when_lonely()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "NvimTree_*",
        nested = true,
        -- This works, because I setted autowriteall to true
        -- FIX: |quit| fails if the file can't be saved by autowriteall ( e.g [No Name] buffers )
        callback = function()
            if vim.fn.winnr("$") == 1 then
                vim.cmd("q")
            end
        end,
        group = vim.api.nvim_create_augroup("NvimTreeQuitWhenLonely", opts),
        desc = "Quit neovim when NvimTree is the only window and tab opened",
    })
end

function M.toggleterm_clear()
    vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
        pattern = "term://*toggleterm#*",
        callback = function()
            if vim.o.hlsearch then
                vim.o.hlsearch = false
            end

            vim.fn.inputsave()
            vim.fn.feedkeys(":", "nx")
            vim.fn.inputrestore()
        end,
        group = vim.api.nvim_create_augroup("CleanTerminal", opts),
        desc = "Disables search highlight and clear command-line messages",
    })
end

return M
