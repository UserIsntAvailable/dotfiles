require("dotscode").setup()

-- TODO: Move to `vscode`

local background = "#151515"
local hl = function(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
end

-- nvim-notify
hl("NotifyERRORBody", { bg = background })
hl("NotifyWARNBody", { bg = background })
hl("NotifyINFOBody", { bg = background })
hl("NotifyDEBUGBody", { bg = background })
hl("NotifyTRACEBody", { bg = background })

-- fidget
hl("FidgetTask", { fg = "#bbbbbb" })
hl("FidgetTitle", { fg = "#777777", bold = true })
