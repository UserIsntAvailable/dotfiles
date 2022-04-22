
vim.g.mapleader = ","

-- Clear highlight
vim.keymap.set("n", "<Leader>l", ":set hlsearch!<CR>", { noremap = true, silent = true})

-- Open Explorer
vim.keymap.set("n", "<Leader>e", ":Lexplore 20<CR>", { noremap = true, silent = true})

-- Map <Space> to / (search)
vim.keymap.set("n", "<space>", "/", { noremap = true })

-- Map Ctrl-<Space> to ? (backwards search)
vim.keymap.set("n", "<C-space>", "?", { noremap = true })

-- Toggle spell checking
vim.keymap.set("n", "<Leader>ss", ":setlocal spell!<CR>", {})
