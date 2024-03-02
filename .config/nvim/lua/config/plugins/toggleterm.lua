local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

local function get_term_height()
    local win_height = vim.o.lines - 3 -- 3 extra lines from tabline, statusline
    -- source: telescope/pickers/layout_strategies.lua
    local has_tbln = (vim.o.showtabline == 2)
        or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)

    if has_tbln then
        return win_height - 1 -- will not hide the tabline
    else
        return win_height
    end
end

toggleterm.setup({
    close_on_exit = true,
    direction = "float",
    float_opts = {
        border = "curved",
        width = vim.o.columns,
        height = get_term_height,
    },
    insert_mappings = false,
    open_mapping = "<c- >",
    persist_size = true,
    persist_mode = true,
    shell = vim.o.shell,
    size = 20,
    terminal_mappings = true,
})

require("config.autocmds").toggleterm_clear()
require("config.keymaps").toggleterm()

-- TODO: Keybinds for Sending lines to the terminal. ( https://github.com/akinsho/toggleterm.nvim#sending-lines-to-the-terminal )
