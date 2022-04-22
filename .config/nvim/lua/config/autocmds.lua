
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "plugins.lua",
        command = "source <afile> | PackerSync",
        group = vim.api.nvim_create_augroup("PackSyncUserConfig", {clear = true}),
        desc = "Reloads neovim whenever you save the plugins.lua file"
    }
)

vim.api.nvim_create_autocmd(
    {"FocusGained", "BufWinEnter"},
    {
        command = "checktime",
        group = vim.api.nvim_create_augroup("CheckChangeOutsideBuffer", {clear = true}),
        desc = "Checks if any buffer was updated outside nvim"
    }
)

local rem_trailling_spaces_grp = vim.api.nvim_create_augroup("RemoveTraillingSpaces", {clear = true})
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = {"text", "c", "cpp", "cs", "java", "python", "lua"},
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
        group = vim.api.nvim_create_augroup("ReturnToLastCursorPos", {clear = true}),
        desc = "Return to last edit position when opening files",
    }
)
