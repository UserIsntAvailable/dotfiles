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

map("<space>", "<NOP>")
vim.g.mapleader = " "

map("<Leader>l", ":set hlsearch!<CR>", "Clear highlight")
map("<Leader>ss", ":setlocal spell!<CR>", "Toggle spell checking")

imap("jk", "<ESC>", "Gets out of insert mode")
imap("jj", "<ESC>", "Gets out of insert mode")
imap("kk", "<ESC>", "Gets out of insert mode")

vmap("p", '"_dP', "Paste text in visual mode without overwriting the current register")

-- Window Resize
map("<C-M-j>", ":res-2<CR>")
map("<C-M-k>", ":res+2<CR>")
map("<C-M-l>", ":vert res-2<CR>")
map("<C-M-h>", ":vert res+2<CR>")

map("<Leader>sf", function()
    if vim.bo.filetype == "lua" then
        vim.cmd("silent! write")
        vim.cmd("source %")
        if vim.fn.fnamemodify(vim.fn.expand("%"), ":t") == "packer.lua" then
            vim.cmd("PackerSync")
        end
        -- TODO: Maybe notify that the file was sourced?
    end
end, "Sources the currrent buffer")

-- plugins keymaps --

-- TODO: Add descriptions to plugins keymaps

function M.lsp_buffer()
    -- TODO: buf_map range_* lsp function
    buf_map("gD", vim.lsp.buf.declaration)
    buf_map("gd", vim.lsp.buf.definition)
    buf_map("K", vim.lsp.buf.hover)
    buf_map("gi", vim.lsp.buf.implementation)
    buf_map("gr", vim.lsp.buf.references)
    buf_map("<C-k>", vim.lsp.buf.signature_help)
    buf_map("<Leader>wa", vim.lsp.buf.add_workspace_folder)
    buf_map("<Leader>wr", vim.lsp.buf.remove_workspace_folder)
    buf_map("<Leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)
    buf_map("<Leader>D", vim.lsp.buf.type_definition)
    buf_map("<Leader>rn", vim.lsp.buf.rename)
    buf_map("<Leader>ca", vim.lsp.buf.code_action)
    buf_map("<Leader>f", function()
        vim.lsp.buf.format({
            --[[
                 TODO: This is the "recommended" way of doing this, but I dont really like it...
                 I need to do it, because if I dont, for some reason, sumneko_lua AND stylua formats
                 the file. I dont know yet if the problem is just cause of this, so I will need
                 futher investigation. ( For now, this solves the problem )
            --]]
            filter = function(clients)
                return vim.tbl_filter(function(client)
                    return client.name ~= "sumneko_lua"
                end, clients)
            end,
        })
    end)
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
            FIX: Doesn't seem to work.
            ["<c-b>"] = cmp.mapping.scroll_docs(-1),
            ["<c-f>"] = cmp.mapping.scroll_docs(1),
        --]]
        ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<c-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<c-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
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
        i = vim.tbl_extend("keep", {
            ["<C-c>"] = "close",
            ["<C-n>"] = "cycle_history_next",
            ["<C-p>"] = "cycle_history_prev",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["C-/"] = "which_key",
        }, in_mode),
        n = vim.tbl_extend("keep", {
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
        }, in_mode),
    }
end

function M.telescope_pickers(ts_builtin)
    map("<Leader>ff", ts_builtin.find_files, "[TLS]: Find files")
    map("<Leader>fg", ts_builtin.live_grep, "[TLS]: Find text on cwd")
    map("<Leader>fh", ts_builtin.help_tags, "[TLS]: Find help tags")
    map("<Leader>fe", ":Telescope env<CR>", "[TLS]: Find environment variables")
    map("<Leader>fr", ":Telescope repo list<CR>", "[TLS]: Find .git repos")
end

function M.bufdelete(bd)
    map("<Leader>bdd", function()
        bd.bufdelete(0, true)
    end, "[BD]: Closes current buffer")
end

function M.bufferline()
    map("<S-h>", ":BufferLineCyclePrev<CR>", "[BL]: Go to previous buffer")
    map("<S-l>", ":BufferLineCycleNext<CR>", "[BL]: Go to next buffer")
    map("<M-H>", ":BufferLineMovePrev<CR>", "[BL]: Move buffer to the left")
    map("<M-L>", ":BufferLineMoveNext<CR>", "[BL]: Move buffer to the right")
    map("<Leader>bp", ":BufferLineTogglePin<CR>", "[BL]: Pin current buffer")
    map("<Leader>bdh", ":BufferLineCloseLeft<CR>", "[BL]: Closes all buffers to the left")
    map("<Leader>bdl", ":BufferLineCloseRight<CR>", "[BL]: Closes all buffers to the left")
    map("<Leader>bff", ":BufferLinePick<CR>", "[BL]: Go to buffer")
    map("<Leader>bfc", ":BufferLinePickClose<CR>", "[BL]: Go to buffer and close")
end

function M.nvim_tree()
    return {
        { key = "L", action = "edit" },
        { key = "H", action = "close_node" },
        { key = "<c-l>", action = "cd" },
        { key = "<c-h>", action = "dir_up" },
        { key = "R", action = "full_rename" },
        { key = "<c-r>", action = "refresh" },
    }
end

function M.nvim_tree_commands()
    map("<Leader>e", ":NvimTreeToggle<CR>", "Open Explorer")
end

return M
