local status_ok, tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

tree.setup({
    disable_netrw = true,
    hijack_cursor = true,
    update_cwd = true,
    actions = {
        open_file = {
            resize_window = false,
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    filters = {
        dotfiles = true,
    },
    view = {
        width = 30,
        side = "right",
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = require("config.keymaps").nvim_tree(),
        },
    },
})

require("config.keymaps").nvim_tree_commands()
require("config.autocmds").nvim_tree_quit_when_lonely()