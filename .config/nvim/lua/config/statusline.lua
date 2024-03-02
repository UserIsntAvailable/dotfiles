-- In depth custom statusline configuration with only lua: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

vim.o.laststatus = 3 -- Show only a single global statusline ( It shows info about the current focused window )
local statusline = {} -- Holds callbacks to configure different states of the statusline

statusline.active = function() -- When windows is active
    -- TODO: Add current branch name to right side ( use gitsigns.nvim )
    return string.format(
        "%s %%=%s",
        [[%#PmenuSel# %{mode()} %#LineNr#%#StatusLine# %F %m]], -- left side
        [[%=%p%% (%l:%c/%L) %#PmenuSel# %{strftime('%H:%M')} %#LineNr#]] -- right side
    )
end

require("config.autocmds").set_statusline(statusline)
