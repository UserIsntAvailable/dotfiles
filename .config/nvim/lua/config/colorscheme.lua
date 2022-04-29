
-- vim.cmd "colorscheme jellybeans-nvim"

local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
    return
end

onedark.setup { style = "warmer" }
onedark.load()

-- vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })
-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#303030", bold = true })
