
-- In depth custom statusline configuration with only lua: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

vim.o.laststatus = 3           -- Show only a single global statusline ( It shows info about the current focused window )
local statusline = {}          -- Holds callbacks to configure different states of the statusline

statusline.active = function() -- When windows is active
    -- TODO: Add current branch name to right side ( use gitsigns.nvim )
    return string.format(
        "%s %%=%s",
        [[%#PmenuSel# %{mode()} %#LineNr#%#StatusLine# %F %m]], -- left side
        [[%=%p%% (%l:%c/%L) %#PmenuSel# %{strftime('%H:%M')} %#LineNr#]] -- right side
    )
end

vim.api.nvim_create_autocmd(
    {"WinEnter", "BufEnter"},
    {
        callback = function() vim.opt_local.statusline = statusline.active() end,
        group = vim.api.nvim_create_augroup("SetActiveStatusLine", {clear = true}),
        desc = "Updates the statusline for the current buffer"
    }
)
