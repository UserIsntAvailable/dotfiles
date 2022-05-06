local M = {}

local opts = { clear = true }

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
    pattern = "packer.lua",
    command = "source <afile> | PackerSync",
    group = vim.api.nvim_create_augroup("PackSyncUserConfig", opts),
    desc = "Reloads neovim whenever you save the packer.lua file"
}
)

vim.api.nvim_create_autocmd(
    { "FocusGained", "BufWinEnter" },
    {
    command = "checktime",
    group = vim.api.nvim_create_augroup("CheckChangeOutsideBuffer", opts),
    desc = "Checks if any buffer was updated outside nvim"
}
)

local rem_trailling_spaces_grp = vim.api.nvim_create_augroup("RemoveTraillingSpaces", opts)
vim.api.nvim_create_autocmd(
    "FileType",
    {
    pattern = { "text", "c", "cpp", "cs", "java", "python", "lua" },
    callback = function() -- Im not really sure if this is the way to do it
        vim.api.nvim_create_autocmd(
            "BufWritePre",
            {
            pattern = "<buffer>",
            callback = function() vim.api.nvim_command([[%s/\s\+$//e]]) end,
            group = rem_trailling_spaces_grp,
            desc = "Delete trailing white spaces on save"
        }
        )
    end,
    group = rem_trailling_spaces_grp,
    desc = "Checks if filetype if valid for trailling white spaces removal"
}
)

vim.api.nvim_create_autocmd(
    "BufReadPost",
    {
    callback = function()
        local line = vim.fn.line
        if line([['"]]) > 1 and line([['"]]) <= line("$") then
            vim.api.nvim_command([[normal! g'"]])
        end
    end,
    group = vim.api.nvim_create_augroup("ReturnToLastCursorPos", opts),
    desc = "Return to last edit position when opening files",
}
)

-- TODO: Take into account packer file and readonly files ( TelescopePrompt )

-- vim.api.nvim_create_autocmd(
-- "InsertLeave",
-- {
-- command = "write",
-- group = vim.api.nvim_create_augroup("SaveBufferOnInsertLeave", opts),
-- desc = "Auto saves when leaving insert mode",
-- }
-- )

-- plugins --

function M.lsp_document_highlight()
    local lsp_document_highlight_grp = vim.api.nvim_create_augroup("LspDocumentHighlight", opts)

    --[[
        If you want to change how fast/slow the token gets highlighted
        change "updatetime" on options.lua
    --]]
    vim.api.nvim_create_autocmd(
        "CursorHold",
        {
        pattern = "<buffer>",
        callback = function() vim.lsp.buf.document_highlight() end,
        group = lsp_document_highlight_grp,
        desc = "Highlights 'syntax tokens' inside of a document"
    }
    )

    vim.api.nvim_create_autocmd(
        "CursorMoved",
        {
        pattern = "<buffer>",
        callback = function() vim.lsp.buf.clear_references() end,
        group = lsp_document_highlight_grp,
        desc = "Clear any highlights when moving the cursor"
    }
    )
end

function M.nvim_tree_quit_when_lonely()
    vim.api.nvim_create_autocmd(
        "BufEnter",
        {
        nested = true,
        callback = function()
            if vim.fn.winnr("$") == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
                vim.api.nvim_command("quit")
            end
        end,
        group = vim.api.nvim_create_augroup("NvimTreeQuitWhenLonely", opts),
        desc = "Quit neovim when NvimTree is the only window and tab opened"
    }
    )
end

return M
