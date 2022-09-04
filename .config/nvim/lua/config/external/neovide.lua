if vim.fn.exists("neovide") == 1 then
    --[ Font (https://github.com/neovide/neovide/issues/1301)
    vim.g.gui_font_default_size = 18
    vim.g.gui_font_size = vim.g.gui_font_default_size
    vim.g.gui_font_face = "ConsolasLigaturized Nerd Font"

    local refreshGuiFont = function()
        vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
    end

    local resizeGuiFont = function(delta)
        vim.g.gui_font_size = vim.g.gui_font_size + delta
        refreshGuiFont()
    end

    local resetGuiFont = function()
        vim.g.gui_font_size = vim.g.gui_font_default_size
        refreshGuiFont()
    end

    -- Call function on startup to set default value
    resetGuiFont()

    local opts = { noremap = true, silent = true }
    vim.keymap.set({ "n", "i" }, "<C-=>", function() resizeGuiFont(1) end, opts)
    vim.keymap.set({ "n", "i" }, "<C-->", function() resizeGuiFont(-1) end, opts)
    vim.keymap.set({ "n", "i" }, "<C-0>", function() resetGuiFont() end, opts)
    --]

    -- Mouse
    vim.api.nvim_set_option("mouse", "a")

    -- Cursor
    vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_trail_length = 0.1
end
