
local M = {}

vim.g.mapleader = ","

-- vim.keymap.set keymaps are noremap by default.

function M.lsp_buffer_keymaps()
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<Leader>f", vim.lsp.buf.formatting, opts)
end

local opts = { silent = true }

function M.luasnip_keymaps(ls)
    vim.keymap.set("i", "<c-j>", function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, opts)

    vim.keymap.set("i", "<c-k>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, opts)

    vim.keymap.set("i", "<c-l>", function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end, opts)
end

function M.cmp_keymaps(cmp)
    return cmp.mapping.preset.insert({
        -- Doesn't seem to work.
        -- ["<c-b>"] = cmp.mapping.scroll_docs(-1),
        -- ["<c-f>"] = cmp.mapping.scroll_docs(1),
        ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<c-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<c-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
        ["<c-l>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
    })
end

-- Map <Space> to / (search)
vim.keymap.set("n", "<space>", "/")

-- Map Ctrl-<Space> to ? (backwards search)
vim.keymap.set("n", "<C-space>", "?")

-- Clear highlight
vim.keymap.set("n", "<Leader>l", ":set hlsearch!<CR>", opts)

-- Open Explorer
vim.keymap.set("n", "<Leader>e", ":Lexplore 20<CR>", opts)

-- Toggle spell checking
vim.keymap.set("n", "<Leader>ss", ":setlocal spell!<CR>", opts)

return M
