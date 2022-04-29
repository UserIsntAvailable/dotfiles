
---[[ VIM user interface
vim.o.backspace = "eol,start,indent"        -- Fixes backspace on INSERT mode
vim.o.completeopt = "menu,menuone,noselect" -- A comma separated list of options for Insert mode completion ins-completion
vim.o.cursorline = true                     -- Only used to highlight CursorLineNr correctly
vim.o.ffs = "unix,dos,mac"	                -- Use Unix as the standard file type
vim.o.ignorecase = true                     -- Ignore case when searching
vim.o.lazyredraw = true                     -- Don't redraw while executing macros
vim.o.mat = 2                               -- How many tenths of a second to blink when matching brackets
vim.o.number = true                         -- Show the number of the current line
vim.o.relativenumber = true                 -- Number of lines numbers will be realtive to the current line
vim.o.scrolloff = 999                       -- Minimal number of screen lines to keep above and bellow the cursor
vim.o.showmatch = true                      -- Show matching brackets when text indicator is over them
vim.o.showmode = false                      -- Doesnt show what is the current mode
vim.o.sidescrolloff = 9                     -- Minimal number of screen lines to keep left and right the cursor
vim.o.smartcase = true                      -- When searching try to be smart about cases
vim.o.splitbelow = true                     -- Force all horizontal splits to go below current window
vim.o.splitright = true                     -- Force all vertical splits to go to the right of current window
vim.o.termguicolors = true                  -- Enable 24-Bit color support
vim.o.tm = 500                              -- Time in ms to wait for a mapped sequence to complete
vim.o.updatetime = 250                      -- Time in ms for the cursor to be considered in "CursorHold" state
vim.o.wrap = false                          -- Don't wrap lines
vim.opt.whichwrap:append "<,>,h,l"          -- Lets you move to prev/next line when being at the start of the end of the current line
--]]

---[[ Files, backups and undo
vim.o.swapfile = false
vim.o.writebackup = false
--]]

---[[ Text, tab and indent related
vim.o.expandtab = true                      -- Use spaces instead of tabs
vim.o.smartindent = true                    -- Smart indent on new lines
vim.o.shiftwidth = 4                        -- 1 tab == 4 spaces
vim.o.tabstop = 4
vim.o.lbr = true                            -- Linebreak on 500 characters
vim.o.tw = 500
--]]
