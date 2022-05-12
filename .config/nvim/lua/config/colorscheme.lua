-- vim.cmd "colorscheme jellybeans-nvim"

local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
    return
end

onedark.setup({ style = "warmer" })
onedark.load()

-- highlighs --

-- Background
local background = "#151515"
vim.api.nvim_set_hl(0, "Normal", { bg = background })
vim.api.nvim_set_hl(0, "NonText", { bg = background })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = background, bg = background }) -- fg hides the ~ at left

-- CursorLine
local cursorLine = "#1c1c1c"
vim.api.nvim_set_hl(0, "CursorLine", { bg = cursorLine })
vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })

-- StatusLine
vim.api.nvim_set_hl(0, "StatusLine", { bg = cursorLine })

-- Terminal colors
vim.g.terminal_color_8 = "#666666"
