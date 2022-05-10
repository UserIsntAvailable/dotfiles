local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

local function get_term_height()
    local win_height = vim.fn.winheight(0)
    -- source: telescope/pickers/layout_strategies.lua
    local tbln = (vim.o.showtabline == 2) or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)

    if tbln then return win_height - 1 else return win_height end
end

toggleterm.setup {
    close_on_exit = true,
    direction = "float",
    float_opts = {
        border = "curved",
        width = function() return vim.fn.winwidth(0) end,
        height = get_term_height,
    },
    insert_mappings = false,
    open_mapping = "<c- >",
    persist_size = true,
    shell = vim.o.shell,
    size = 20,
    terminal_mappings = true,
}

vim.api.nvim_set_var("terminal_color_8", "#666666") -- TODO: Move to colorscheme.lua?

-- TODO: Keybinds for Sending lines to the terminal. ( https://github.com/akinsho/toggleterm.nvim#sending-lines-to-the-terminal )

-- vim.api.nvim_create_autocmd(
    -- "TermOpen",
    -- {
        -- pattern = "term://*toggleterm#*",
        -- callback = function ()
            -- vim.cmd[[
                -- set hlsearch! -- FIX: The highlight is not getting removed
                -- call inputsave()
                -- call feedkeys(':', 'nx')
                -- call inputrestore()
            -- ]]
        -- end,
        -- group = vim.api.nvim_create_augroup("ResizeTerminal", {clear = true}),
        -- desc = "Disables search highlight and clear command-line messages",
    -- }
-- )

-- vim.api.nvim_create_autocmd(
    -- "VimResized",
    -- {
        -- pattern = "term://*toggleterm#*",
        -- callback = function ()
            -- vim.cmd[[
                -- ToggleTerm
                -- ToggleTerm
            -- ]]
            -- -- FIX: After the second ToggleTerm, the terminal is in normal mode.
            -- -- ( I think the reason is that toggleterm has their own autocmds that are not being called for some reason. )
        -- end,
        -- group = vim.api.nvim_create_augroup("ResizeTerminal", {clear = true}),
        -- desc = "Resizes the toggleterm terminal even if is currently open"
    -- }
-- )
