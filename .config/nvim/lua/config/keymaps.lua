local M = {}

-- utils --

local function set_keymap(mode, lhs, rhs, desc, opts)
    if not opts then
        opts = { buffer = false }
    end
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, buffer = opts.buffer })
end

local function map(lhs, rhs, desc)
    set_keymap("n", lhs, rhs, desc)
end

local function buf_map(lhs, rhs, desc)
    set_keymap("n", lhs, rhs, desc, { buffer = true })
end

local function imap(lhs, rhs, desc)
    set_keymap("i", lhs, rhs, desc)
end

local function vmap(lhs, rhs, desc)
    set_keymap("v", lhs, rhs, desc)
end

-- general keymaps --

vim.g.mapleader = " "

map("<Leader>l", ":set hlsearch!<CR>", "Clear highlight")
map("<Leader>e", ":Lexplore 20<CR>", "Open Explorer")
map("<Leader>ss", ":setlocal spell!<CR>", "Toggle spell checking")

imap("jk", "<ESC>", "Gets out of insert mode")
vmap("p", '"_dP', "Paste text in visual mode without overwriting the current register")

map("<S-l>", ":bnext<CR>", "Go to next buffer")
map("<S-h>", ":bprevious<CR>", "Go to previous buffer")

-- Window Resize
map("<C-M-j>", ":res-2<CR>")
map("<C-M-k>", ":res+2<CR>")
map("<C-M-l>", ":vert res-2<CR>")
map("<C-M-h>", ":vert res+2<CR>")

-- plugins keymaps --

-- TODO: Add descriptions to plugins keymaps

function M.lsp_buffer()
    buf_map("gD", vim.lsp.buf.declaration)
    buf_map("gd", vim.lsp.buf.definition)
    buf_map("K", vim.lsp.buf.hover)
    buf_map("gi", vim.lsp.buf.implementation)
    buf_map("gr", vim.lsp.buf.references)
    buf_map("<C-k>", vim.lsp.buf.signature_help)
    buf_map("<Leader>wa", vim.lsp.buf.add_workspace_folder)
    buf_map("<Leader>wr", vim.lsp.buf.remove_workspace_folder)
    buf_map("<Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
    buf_map("<Leader>D", vim.lsp.buf.type_definition)
    buf_map("<Leader>rn", vim.lsp.buf.rename)
    buf_map("<Leader>ca", vim.lsp.buf.code_action)
    buf_map("<Leader>f", vim.lsp.buf.formatting)
end

function M.luasnip(ls)
    imap("<c-j>", function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end)

    imap("<c-k>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end)

    imap("<c-l>", function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end)
end

function M.cmp(cmp)
    return cmp.mapping.preset.insert({
        --[[
            TODO: Doesn't seem to work.
            ["<c-b>"] = cmp.mapping.scroll_docs(-1),
            ["<c-f>"] = cmp.mapping.scroll_docs(1),
        --]]
        ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<c-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<c-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
        ["<c-l>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
    })
end

function M.telescope()
    local in_mode = {
        ["<C-l>"] = "select_default",
        ["<C-x>"] = "select_horizontal",
        ["<C-v>"] = "select_vertical",
        ["<C-t>"] = "select_tab",
        ["<C-u>"] = "preview_scrolling_up",
        ["<C-d>"] = "preview_scrolling_down",
    }

    return {
        i = vim.tbl_extend(
            "keep",
            {
                ["<C-c>"] = "close",
                ["<C-n>"] = "cycle_history_next",
                ["<C-p>"] = "cycle_history_prev",
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["C-/"] = "which_key",
            },
            in_mode
        ),
        n = vim.tbl_extend(
            "keep",
            {
                ["q"] = "close",
                ["<esc>"] = "close",
                ["gg"] = "move_to_top",
                ["G"] = "move_to_bottom",
                ["j"] = "move_selection_next",
                ["k"] = "move_selection_previous",
                ["H"] = "move_to_top",
                ["M"] = "move_to_middle",
                ["L"] = "move_to_bottom",
                ["?"] = "which_key",
            },
            in_mode
        )
    }
end

function M.telescope_pickers(ts_builtin)
    map("<Leader>ff", ts_builtin.find_files, "[TLS]: Find files")
    map("<Leader>fg", ts_builtin.live_grep, "[TLS]: Find text on cwd")
    map("<Leader>fh", ts_builtin.help_tags, "[TLS]: Find help tags")
    map("<Leader>fe", ":Telescope env<CR>", "[TLS]: Find environment variables")
    map("<Leader>fr", ":Telescope repo list<CR>", "[TLS]: Find .git repos")
end

return M
