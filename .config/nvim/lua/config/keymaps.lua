
vim.g.mapleader = ","

-- Clear highlight
vim.api.nvim_set_keymap("n", "<Leader>l", ":set hlsearch!<CR>", { noremap = true, silent = true})

-- Open Explorer
vim.api.nvim_set_keymap("n", "<Leader>e", ":Lexplore<CR>", { noremap = true, silent = true})

-- Map <Space> to / (search)
vim.api.nvim_set_keymap("n", "<space>", "/", {})

-- Map Ctrl-<Space> to ? (backwards search)
vim.api.nvim_set_keymap("n", "<C-space>", "?", {})

-- Toggle spell checking
vim.api.nvim_set_keymap("n", "<Leader>ss", ":setlocal spell!<CR>", {})
