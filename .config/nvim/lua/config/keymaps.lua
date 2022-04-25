
local M = {}

vim.g.mapleader = ","

-- vim.keymap.set keymaps are noremap by default.

function M.lsp_buffer_keymaps()
    local opts = { buffer = true, silent=true }
    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set('n', '<Leader>wa', function() vim.lsp.buf.add_workLeader_folder() end, opts)
    vim.keymap.set('n', '<Leader>wr', function() vim.lsp.buf.remove_workLeader_folder() end, opts)
    vim.keymap.set('n', '<Leader>wl', function() print(inspect(vim.lsp.buf.list_workLeader_folders())) end, opts)
    vim.keymap.set('n', '<Leader>D', function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set('n', '<Leader>rn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', '<Leader>ca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.formatting() end, opts)
end

local opts = { silent=true }

-- Map <Space> to / (search)
vim.keymap.set("n", "<space>", "/", {})

-- Map Ctrl-<Space> to ? (backwards search)
vim.keymap.set("n", "<C-space>", "?", {})

-- Clear highlight
vim.keymap.set("n", "<Leader>l", ":set hlsearch!<CR>", opts)

-- Open Explorer
vim.keymap.set("n", "<Leader>e", ":Lexplore 20<CR>", opts)

-- Toggle spell checking
vim.keymap.set("n", "<Leader>ss", ":setlocal spell!<CR>", opts)

return M
