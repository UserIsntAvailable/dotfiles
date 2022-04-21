
vim.o.laststatus = 3        -- Show only a single global statusline ( It shows info about the current focused window )

vim.o.statusline=[[%#PmenuSel# %{mode()} %#LineNr#%#Pmenu# %F %m ]] --left side
--TODO: Add current branch name to right side
vim.opt.statusline:append [[%=%#Pmenu# %p%% (%l:%c/%L) %#PmenuSel# %{strftime('%H:%M')} %#LineNr# ]] --right side
