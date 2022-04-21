
vim.api.nvim_create_autocmd(
    {"FocusGained", "BufWinEnter"},
    {command = "checktime"}
)

-- TODO: Convert to nvim autocmd api ( I dont have any idea how to properly do it )
-- Delete trailing white space on save.
-- Return to last edit position when opening files
vim.cmd [[
    autocmd FileType txt,c,cpp,cs,java,lua,py autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]
