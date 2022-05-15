local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

local keymaps = require("config.keymaps")

-- TODO: I dont't think I need this, since I can use lsp instead? https://github.com/nvim-treesitter/nvim-treesitter-refactor

treesitter.setup({
    ensure_installed = {
        "bash",
        "c_sharp",
        "lua",
        "markdown",
    },
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = keymaps.treesitter_incremental_selection(),
    },
    indent = { enable = true },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = keymaps.treesitter_textobjects_select(),
        },
        lsp_interop = {
            enable = true,
            border = "none",
            peek_definition_code = keymaps.treesitter_textobjects_lsp_interop(),
        },
        move = vim.tbl_extend("keep", {
            enable = true,
            set_jumps = true,
        }, keymaps.treesitter_textobjects_move()),
        -- TODO: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/182 will make this better
        swap = vim.tbl_extend("keep", {
            enable = true,
        }, keymaps.treesitter_textobjects_swap()),
    },
})
