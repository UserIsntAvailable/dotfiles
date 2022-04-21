
---[[ VIM user interface
vim.o.showmode = false      -- Doesnt show what is the current mode
vim.o.cursorline = true     -- Only used to highlight CursorLineNr correctly
vim.o.number = true         -- Show the number of the current line
vim.o.relativenumber = true -- Number of lines numbers will be realtive to the current line
vim.o.ignorecase = true     -- Ignore case when searching
vim.o.smartcase = true      -- When searching try to be smart about cases
vim.o.lazyredraw = true     -- Don't redraw while executing macros
vim.o.showmatch = true      -- Show matching brackets when text indicator is over them
vim.o.tm = 500              -- Time in milliseconds to wait for a mapped sequence to complete
vim.o.mat = 2               -- How many tenths of a second to blink when matching brackets
vim.o.ffs = "unix,dos,mac"	-- Use Unix as the standard file type
--]]

---[[ Files, backups and undo
vim.o.writebackup = false
vim.o.swapfile = false
--]]

---[[ Text, tab and indent related
vim.o.expandtab = true      -- Use spaces instead of tabs
vim.o.shiftwidth = 4        -- 1 tab == 4 spaces
vim.o.tabstop = 4
vim.o.lbr = true            -- Linebreak on 500 characters
vim.o.tw = 500
vim.o.smartindent = true    -- Smart indent on new lines
--]]
