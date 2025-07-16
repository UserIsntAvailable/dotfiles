-- Helpers

local api = vim.api
local fn = vim.fn
local opt = vim.opt

local ac = api.nvim_create_autocmd

--- Create an autocommand group (with `clear = true`).
---
--- @param name string String: The name of the group
--- @return integer Integer id of the created group.
local function ag(name)
  return api.nvim_create_augroup(name, { clear = true })
end

local function map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc

  opts = vim.tbl_extend("force", {
    silent = true,
    buffer = false,
  }, opts)

  vim.keymap.set(mode, lhs, rhs, opts)
end

local function mapb(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.buffer = true
  map(mode, lhs, rhs, desc, opts)
end

local function nmap(lhs, rhs, desc, opts)
  map("n", lhs, rhs, desc, opts)
end

local function nmapb(lhs, rhs, desc, opts)
  mapb("n", lhs, rhs, desc, opts)
end

---@diagnostic disable-next-line: unused-function, unused-local
local function imap(lhs, rhs, desc, opts)
  map("i", lhs, rhs, desc, opts)
end

local function vmap(lhs, rhs, desc, opts)
  map("v", lhs, rhs, desc, opts)
end

local function tmap(lhs, rhs, desc, opts)
  map("t", lhs, rhs, desc, opts)
end

-- Options

-- stylua: ignore start
opt.autowriteall = true                   -- When performing a destructive action on a buffer (e.g q) write to the file automatically
opt.cmdheight = 0                         -- Completely removes the command-line bar at the bottom
opt.completeopt = "menu,menuone,noselect" -- A comma separated list of options for Insert mode completion ins-completion
opt.cursorline = true                     -- Only used to highlight CursorLineNr correctly
opt.expandtab = true                      -- Use spaces instead of tabs
opt.fileformats = "unix,dos,mac"          -- Use Unix as the standard file type
opt.ignorecase = true                     -- Ignore case when searching
opt.inccommand = "split"                  -- Shows in a split modifications from :substitute command
opt.lazyredraw = true                     -- Don't redraw while executing macros
opt.linebreak = true                      -- Wrap long lines
opt.matchtime = 2                         -- How many tenths of a second to blink when matching brackets
opt.mouse = ""                            -- Disables mouse
opt.number = true                         -- Show the number of the current line
opt.relativenumber = true                 -- Number of lines numbers will be relative to the current line
opt.scrolloff = 999                       -- Minimal number of screen lines to keep above and bellow the cursor
opt.sessionoptions:append("globals")      -- Keeps track of global variables on between nvim sessions
opt.shiftwidth = 4                        -- Use 4 spaces when autoident
opt.showmatch = true                      -- Show matching brackets when text indicator is over them
opt.showmode = false                      -- Doesn't show what is the current mode
opt.sidescrolloff = 5                     -- Minimal number of screen lines to keep left and right the cursor
opt.smartcase = true                      -- When searching try to be smart about cases
opt.smartindent = true                    -- Smart indent on new lines
opt.splitbelow = true                     -- Force all horizontal splits to go below current window
opt.splitright = true                     -- Force all vertical splits to go to the right of current window
opt.swapfile = false                      -- Use a swapfile for the buffer.
opt.tabstop = 4                           -- 1 tab == 4 spaces
opt.termguicolors = true                  -- Enable 24-Bit color support
opt.textwidth = 500                       -- Maximum width of text that is being inserted. A longer line will be broken after white space to get this width.
opt.timeoutlen = 500                      -- Time in ms to wait for a mapped sequence to complete
opt.undofile = true                       -- Automatically saves undo history to an undo file when writing a buffer to a file
opt.updatetime = 250                      -- Time in ms for the cursor to be considered in "CursorHold" state
opt.whichwrap:append("<,>,h,l")           -- Lets you move to prev/next line when being at the start of the end of the current line
opt.wrap = false                          -- Don't wrap lines
-- stylua: ignore end

-- .StatusLine

opt.laststatus = 3 -- Have a global statusline at the bottom instead of one per window
opt.statusline = string.format( -- Format string of statusline
  "%s %%=%s",
  [[%#PmenuSel# %{mode()} %#LineNr#%#StatusLine# %F %m]], -- left side
  [[%=%p%% (%l:%c/%L) %#PmenuSel# %{strftime('%H:%M')} %#LineNr#]] -- right side
)

-- Autocommands (General)

ac({ "FocusGained", "BufWinEnter" }, {
  command = "checktime",
  group = ag("CheckChangeOutsideBuffer"),
  desc = "Checks if any buffer was updated outside nvim",
})

ac("BufReadPost", {
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local row, col = mark[1], mark[2]
    if { row, col } ~= { 0, 0 } and row <= api.nvim_buf_line_count(0) then
      api.nvim_win_set_cursor(0, { row, 0 })
    end
  end,
  group = ag("ReturnToLastCursorPos"),
  desc = "Return to last cursor position (line) when opening files",
})

ac("BufWritePre", {
  callback = function()
    -- The substitution below changes the cursor position, so keep the
    -- previous state before removing any spaces.
    local view = fn.winsaveview()
    api.nvim_command([[%s/\s\+$//e]])
    fn.winrestview(view)
  end,
  group = ag("RemoveTraillingSpaces"),
  desc = "Delete trailing white spaces on save",
})

-- TODO(Unavailable): Toggle option to desactivate autosave.
ac({ "InsertLeave", "TextChanged" }, {
  callback = function()
    local buf_name = fn.fnamemodify(api.nvim_buf_get_name(0), ":t")
    if
      api.nvim_get_option_value("modifiable", { buf = 0 })
      and buf_name ~= "" -- Checks if the buffer has a file attached to it
    then
      vim.cmd("silent! write")
    end
  end,
  group = ag("AutoWriteBuffer"),
  desc = "Auto writes when leaving insert mode or when normal mode modifies text",
})

ac("FileType", {
  pattern = { "gitcommit", "markdown", "tex" },
  command = "set textwidth=72",
  group = ag("MarkdownOptions"),
  desc = "Set some options intended for Markdown like files",
})

ac("FileType", {
  pattern = { "conf", "gitcommit", "html", "json", "kdl", "lua", "markdown", "yaml" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
  group = ag("SwTsEquals2"),
  desc = "Set `shiftwidth` and `tabstop` to `2` for specific filetypes",
})

ac("TermEnter", {
  command = "set nohlsearch",
  group = ag("ClearSearchHl"),
  desc = "Clear search highlight when opening terminal windows",
})

-- Keymaps (General)

nmap("<space>", "<NOP>")
vim.g.mapleader = " "

nmap("<Leader>l", ":set hlsearch!<CR>", "Clear highlights")
nmap("<Leader>ss", ":setlocal spell!<CR>", "Toggle spell checker")
vmap("p", '"_dP', "Paste text in visual mode without overwriting the current register")
vmap("<Leader>f", function()
  -- "<" and ">" are only set after exiting visual mode.
  vim.cmd([[execute "normal! \<ESC>"]])

  local row_start = api.nvim_buf_get_mark(0, "<")[1] - 1
  local row_end = api.nvim_buf_get_mark(0, ">")[1]
  local lines = api.nvim_buf_get_lines(0, row_start, row_end, false)

  local cmd = { "prettier", "--parser=html" }
  local opts = { stdin = lines, text = true }
  local result = vim.system(cmd, opts):wait()

  if result.code ~= 0 then
    vim.notify("Process exited with: " .. result.code, vim.log.levels.ERROR)
    return
  end

  local indent = string.rep(" ", lines[1]:len() - lines[1]:gsub("^%s+", ""):len())
  local output = vim.split(result.stdout, "\n", { plain = true, trimempty = true })
  for idx, line in ipairs(output) do
    output[idx] = indent .. line
  end

  api.nvim_buf_set_lines(0, row_start, row_end, false, output)
end, "Use prettier to format lines as html")

-- Window Resize
nmap("<C-M-j>", ":res-2<CR>")
nmap("<C-M-k>", ":res+2<CR>")
nmap("<C-M-l>", ":vert res-2<CR>")
nmap("<C-M-h>", ":vert res+2<CR>")

-- Quickfix
nmap("<M-q>", function()
  local qf_buf = vim.iter(api.nvim_list_bufs()):find(function(id)
    return api.nvim_get_option_value("ft", { buf = id }) == "qf"
  end)
  if qf_buf ~= nil and fn.buflisted(qf_buf) == 1 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, "Toggle the quickfix window")

-- Custom

-- I'm dyslexic (not really); I can't even type my name...
fn.setreg("u", "Unavailable")

-- Package Manager

-- .Bootstrap
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    fn.getchar()
    os.exit(1)
  end
end
opt.rtp:prepend(lazypath)

-- TODO(Unavailable): Run `checkhealth lazy` after bootstraping.

local plugins = {
  -- Library (can always lazy load)
  { "nvim-lua/plenary.nvim", lazy = true }, -- Useful lua functions used by lots of plugins
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- API to work with icons easier

  -- Colorscheme
  { -- The BEST colorscheme out there (fight me).
    "Mofiqul/vscode.nvim",
    priority = 1000,
    opts = {
      underline_links = true,
      terminal_colors = false,
    },
    config = function(_, opts)
      local color_overrides = {
        vscBack = "#151515",

        vscTabCurrent = "#1E1E1E",

        vscPopupFront = "#ABB2BF",
        vscPopupBack = "#282C34",

        vscPopupHighlightLightBlue = "#569CD6",

        vscCursorDarkDark = "#1C1C1C",
        vscSelection = "#3E4452",

        vscSearchCurrent = "#5C6370",
        vscSearch = "#5C6370",

        vscGray = "#5A5B5E",
      }

      local c = vim.tbl_extend("force", require("vscode.colors").get_colors(), color_overrides)

      local group_overrides = {
        Comment = { fg = c.vscGray },
        CursorLineNr = { fg = c.vscPopupFront, bg = c.vscBack, bold = true },
        CurSearch = { link = "Search" },
        PmenuSel = { fg = c.vscBack, bg = c.vscPopupHighlightLightBlue },
        StatusLine = { fg = c.vscFront, bg = c.vscCursorDarkDark },
        Todo = { fg = c.vscLightBlue, bold = true },
        SnippetTabStop = {},

        -- TreeSitter

        ["@comment.note"] = { fg = c.vscFront, bold = true },
        ["@constant"] = { fg = c.vscYellow },
        ["@constant.comment"] = { fg = c.vscFront, bold = true, underline = true },
        ["@constructor"] = { link = "@type" },
        ["@keyword.import"] = { link = "@keyword" },
        ["@keyword.return"] = { link = "@keyword" },
        ["@markup.heading"] = { fg = c.vscFront, bold = true },
        ["@markup.link.label"] = { fg = c.vscFront, underline = true },
        ["@string.escape"] = { fg = c.vscOrange, bold = true },
        ["@variable.builtin"] = { link = "@variable" },

        -- LSP

        ["@lsp.type.comment"] = {}, -- Prevents `todo` and friends highlights to be removed.

        DiagnosticWarn = { fg = c.vscYellowOrange },
        DiagnosticHint = { link = "@comment.note" },
        DiagnosticInfo = { fg = c.vscFront },
        DiagnosticUnderlineWarn = { fg = c.vscNone, undercurl = true, sp = c.vscYellowOrange },
        DiagnosticUnderlineInfo = {},
        DiagnosticUnderlineHint = {},
        DiagnosticUnnecessary = { link = "Comment" },

        -- Languages

        -- .kdl
        ["@tag.kdl"] = { link = "@property.kdl" },

        -- .lua
        ["@constructor.lua"] = { link = "@operator" },

        -- .python
        ["@attribute.builtin.python"] = {},

        -- .rust
        ["@lsp.type.lifetime.rust"] = { link = "@operator" },
        ["@lsp.typemod.selfKeyword.crateRoot.rust"] = { link = "@keyword" },
        ["@lsp.typemod.enumMember.defaultLibrary.rust"] = { link = "@keyword" },

        -- .ts
        ["@lsp.typemod.variable.readonly.typescript"] = {},

        -- Plugins

        BlinkCmpLabelDeprecated = {
          fg = c.vscCursorDark,
          bg = c.vscPopupBack,
          strikethrough = true,
        },
        BlinkCmpKind = { link = "Pmenu" },
        BlinkCmpKindClass = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindColor = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindConstant = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindConstructor = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindCopilot = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindEnum = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindEnumMember = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindEvent = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindField = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindFile = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindFolder = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindFunction = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindInterface = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindKeyword = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindMethod = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindModule = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindOperator = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindProperty = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindReference = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindSnippet = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindStruct = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindText = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindTypeParameter = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindUnit = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindValue = { fg = c.vscFront, bg = c.vcsNone },
        BlinkCmpKindVariable = { fg = c.vscFront, bg = c.vcsNone },
      }

      opts.color_overrides = color_overrides
      opts.group_overrides = group_overrides

      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- TreeSitter
  { -- TODO(Unavailable): Move to `main` branch once completed.
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- sets main module to use for opts
    opts = {
      ensure_installed = "all",
      ignore_install = { "ipkg" }, -- FIXME(Unavailable): remove when moving to `main`.
      sync_install = false,
      -- FIXME(Unavailable): `auto_install = false` seems to be bugged.
      auto_install = true,

      -- Modules

      highlight = {
        enable = true,
        -- disable = function(lang, bufnr)
        -- -- FIXME(Unavailable): Disable on single line buffers with a lot of tokens.
        -- -- e.g json, html, css, or js (minified) files
        -- end
      },
      indent = { enable = true },
      -- TODO(Unavailable): https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      -- TODO(Unavailable): https://github.com/nvim-treesitter/nvim-treesitter-context
    },
  },

  { -- Sets the commentstring option based on the current treesitter node.
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },

  "windwp/nvim-ts-autotag", -- Use treesitter to autoclose and autorename html tags

  -- TODO(Unavailable): https://github.com/luckasRanarison/tailwind-tools.nvim

  -- Completions
  { -- Performant, batteries-included completion plugin for Neovim.
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    dev = false,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-l>"] = { "select_and_accept", "fallback" },
        ["<C- >"] = { "show" },
        ["<C-e>"] = { "hide" },
        ["<C-n>"] = { "scroll_documentation_up", "fallback" },
        ["<C-p>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        accept = {
          create_undo_point = false,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          update_delay_ms = 50,
        },
        ghost_text = {
          enabled = true,
          show_with_selection = false,
          show_without_selection = true,
        },
        keyword = {
          -- Fuzzy match on the text before *and* after the cursor.
          range = "full",
        },
        list = {
          -- Maximum number of items to display.
          max_items = 100,
          selection = {
            -- Don't select the first item automatically
            preselect = false,
          },
        },
        menu = {
          -- Keep the cursor X lines away from the top/bottom of the window.
          scrolloff = 0,
          draw = {
            columns = {
              { "label" },
              { "kind_icon" },
              { "kind" },
              { "source_name" },
            },
          },
        },
      },
      signature = {
        enabled = false,
        trigger = {
          show_on_insert_on_trigger_character = false,
        },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { name = "[lsp]" },
          path = { name = "[path]" },
          snippets = { name = "[snip]" },
          buffer = { name = "[buf]" },
          cmdline = { name = "[cmd]" },
          lazydev = {
            name = "[lazydev]",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- make lazydev completions top priority
          },
          -- TODO(Unavailable): Create blink source for `cmp-calc`.
        },
      },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = {
          menu = {
            auto_show = function(_)
              return fn.getcmdtype() == ":"
            end,
          },
        },
      },
      appearance = {
        -- Yoinked from https://github.com/onsails/lspkind.nvim
        kind_icons = {
          Variable = "󰀫",

          Class = "󰠱",
          Interface = "",
          Struct = "󰙅",
          Module = "",

          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          EnumMember = "",

          Keyword = "󰌋",

          Snippet = "",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          Operator = "󰆕",
        },
      },
    },
  },

  { -- Auto completes characters pairs
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_in_macro = false,
      map_c_w = true,
    },
  },

  -- LSP
  { -- Provides basic, default Nvim LSP client configurations for various LSP servers.
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-telescope/telescope.nvim",

      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",

      "Decodetalkers/csharpls-extended-lsp.nvim",
      "Hoffs/omnisharp-extended-lsp.nvim",
      -- TODO(Unavailable): https://github.com/pmizio/typescript-tools.nvim
    },
    config = function(_, _)
      --- @type { [string]: boolean|vim.lsp.Config }
      local servers = {
        astro = true,
        clangd = true,
        csharp_ls = false,
        hls = {
          manual_install = true,
        },
        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
        },
        -- TODO(Unavailable): Setup decompilation handlers
        omnisharp = {
          settings = {
            FormattingOptions = {
              OrganizeImports = true,
            },
            RoslynExtensionsOptions = {
              AnalyzeOpenDocumentsOnly = true,
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
              EnableDecompilationSupport = true,
            },
            RenameOptions = {
              RenameInComments = true,
              RenameOverloads = true,
            },
          },
        },
        rust_analyzer = {
          manual_install = true,
        },
        tailwindcss = true,
        ts_ls = true,
      }

      local install_with_mason = vim
        .iter(servers)
        :filter(function(_, v)
          if type(v) == "table" then
            return not v.manual_install
          else
            return v
          end
        end)
        :map(function(k, _)
          return k
        end)

      require("mason-lspconfig").setup({
        automatic_enable = false,
        ensure_installed = install_with_mason:totable(),
      })

      for name, config in pairs(servers) do
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.lsp.enable(name, config)
        if type(config) == "table" then vim.lsp.config(name, config) end
      end

      local builtin = require("telescope.builtin")

      api.nvim_create_autocmd("LspAttach", {
        group = ag("MainLspAttach"),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          assert(client, "must have valid client")

          local config = servers[client.name]
          if type(config) ~= "table" then config = {} end

          if config.server_capabilities then
            for k, v in pairs(config.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end
              client.server_capabilities[k] = v
            end
          end

          nmapb("gd", builtin.lsp_definitions, "[LSP]: Go to definition")
          nmapb("gr", builtin.lsp_references, "[LSP]: Go to reference")
          nmapb("K", vim.lsp.buf.hover, "[LSP]: Hover menu")

          nmapb("<Leader>rn", vim.lsp.buf.rename, "[LSP]: Rename the symbol under the cursor")
          mapb({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, "[LSP]: Code actions")
          nmapb(
            "<Leader>fs",
            builtin.lsp_document_symbols,
            "[LSP]: Find all symbols in the current document"
          )
          nmapb(
            "<Leader>fw",
            builtin.lsp_workspace_symbols,
            "[LSP]: Find all symbols in the current workspace"
          )

          -- Hints Mode (inlay_hints + document_highlight)

          local supports_inlay_hints =
            client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
          local supports_document_hl =
            client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)

          nmap("<Leader>th", function()
            local enable_hints = not vim.lsp.inlay_hint.is_enabled()

            if supports_document_hl then
              local group = ag("LspEnabledDocumentHighlight")

              local function disable_document_highlight()
                vim.lsp.buf.clear_references()
                api.nvim_clear_autocmds({ group = group })
              end

              ac({ "CursorHold", "CursorHoldI" }, {
                group = group,
                callback = vim.lsp.buf.document_highlight,
              })

              ac({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
                group = group,
                callback = vim.lsp.buf.clear_references,
              })

              ac("LspDetach", {
                group = ag("LspDisabledDocumentHighlight"),
                callback = disable_document_highlight,
              })

              if not enable_hints then disable_document_highlight() end
            end

            if supports_inlay_hints then vim.lsp.inlay_hint.enable(enable_hints) end
          end, "[LSP]: Toggle hints mode (if the client supports it)")
        end,
      })

      vim.diagnostic.config({
        signs = false,
        update_in_insert = true,
      })

      nmap(
        "<Leader>od",
        vim.diagnostic.open_float,
        "[LSP]: Show current diagnostic under the cursor"
      )
      nmap("<Leader>fd", function()
        builtin.diagnostics({ bufnr = 0 })
      end, "[LSP]: Show all diagnostics in the current buffer")
    end,
  },

  { -- Extensible UI for neovim notifications and LSP progress messages.
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        display = {
          progress_icon = { "moon" },
          done_ttl = 2,
          done_style = "Comment",
        },
      },
      notification = {
        window = {
          normal_hl = "Normal",
          winblend = 0,
        },
      },
    },
  },

  { -- Configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = "Bilal2453/luvit-meta", -- FIXME(0.12): not needed
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        -- TODO(Unavailable): Add my personal projects.
      },
    },
  },

  { -- Lightweight yet powerful formatter plugin for Neovim
    "stevearc/conform.nvim",
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        astro = { "prettier" },
        cs = { "csharpier" },
        javascript = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_format" },
        sh = { "shfmt" },
        typescript = { "prettier" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters = {
        shfmt = {
          prepend_args = {
            "--indent",
            "4",
            "--binary-next-line",
            "--case-indent",
            "--func-next-line",
          },
        },
      },
    },
    config = function(_, opts)
      local conform = require("conform")
      conform.setup(opts)

      nmap("<Leader>f", function()
        conform.format({ async = true })
      end, "[CF]: Format the current buffer")
    end,
  },

  { -- An asynchronous linter plugin for Neovim complementary to the
    -- built-in Language Server Protocol support.
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
      }

      ac({ "InsertLeave", "TextChanged" }, {
        callback = function()
          require("lint").try_lint()
        end,
        group = ag("NvimLintTryLint"),
      })
    end,
  },

  -- Telescope
  { -- Find, Filter, Preview, Pick. All lua, all the time.
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          local found = fn.executable("make") == 1
          local msg = "command not found: make"
          local level = vim.log.levels.ERROR
          if not found then vim.notify(msg, level) end
          return found
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "Decodetalkers/csharpls-extended-lsp.nvim",
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-l>"] = "select_default",
            ["<C-n>"] = "cycle_history_next",
            ["<C-p>"] = "cycle_history_prev",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
          n = {
            ["<C-l>"] = "select_default",
            ["q"] = "close",
          },
        },
      },
      pickers = {
        builtin = { previewer = false, theme = "dropdown" },
        diagnostics = { theme = "dropdown" },
        find_files = { previewer = false },
        grep_string = { layout_strategy = "vertical" },
        live_grep = { layout_strategy = "vertical" },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")

      opts.extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      }
      telescope.setup(opts)

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "notify")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "csharpls_definition")

      local builtin = require("telescope.builtin")

      nmap("<Leader>fa", function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, "[TLS]: Find ALL (hidden and ignored included) files")
      nmap("<Leader>fb", builtin.builtin, "[TLS]: Find Telescope Builtin Pickers")
      nmap("<Leader>ff", builtin.find_files, "[TLS]: Find Files")
      nmap("<Leader>fg", builtin.live_grep, "[TLS]: Live Grep")
      nmap("<Leader>fh", builtin.help_tags, "[TLS]: Help Tags")
      nmap("<Leader>fn", function()
        builtin.find_files({ search_dirs = vim.split(vim.o.runtimepath, ",") })
      end, "[TLS]: Find `:runtimepath` Neovim Files")
      nmap(
        "<Leader>fz",
        builtin.spell_suggest,
        "[TLS]: Lists spelling suggestions for the word under the cursor"
      )
    end,
  },

  -- Miscellaneous
  { -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
  },

  { -- A fancy, configurable, notification manager for NeoVim
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
      render = "compact",
      stages = "fade",
      top_down = true,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  { -- Allows to delete a buffer without messing up window layouts
    -- (unlike `:bdelete`).
    "famiu/bufdelete.nvim",
    config = function()
      nmap("<Leader>bdd", function()
        require("bufdelete").bufdelete(0, true)
      end, "[BD]: Closes current buffer")
    end,
  },

  { -- The name says it all :)
    "akinsho/bufferline.nvim",
    dependencies = {
      "famiu/bufdelete.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        close_command = function(bufnum)
          require("bufdelete").bufdelete(bufnum, true)
        end,
        custom_filter = function(bufnum)
          -- removes quickfix and checkhealth buffers
          return not vim.tbl_contains({ "checkhealth", "qf", "man" }, vim.bo[bufnum].ft)
        end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count)
          return string.format("(%s)", count)
        end,
        get_element_icon = function(el)
          local devicons = require("nvim-web-devicons")
          return devicons.get_icon_by_filetype(el.filetype, { default = true })
        end,
        modified_icon = "",
        name_formatter = function(buf)
          -- show only file tail (name+ext)
          return fn.fnamemodify(buf.name, ":t")
        end,
        show_buffer_close_icons = false,
        show_close_icon = false,
        sort_by = "insert_at_end",
        tab_size = 0, -- take the minimum size
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)

      nmap("<S-h>", ":BufferLineCyclePrev<CR>", "[BL]: Go to previous buffer")
      nmap("<S-l>", ":BufferLineCycleNext<CR>", "[BL]: Go to next buffer")
      nmap("<M-H>", ":BufferLineMovePrev<CR>", "[BL]: Move buffer to the left")
      nmap("<M-L>", ":BufferLineMoveNext<CR>", "[BL]: Move buffer to the right")
      nmap("<Leader>bdh", ":BufferLineCloseLeft<CR>", "[BL]: Closes all buffers to the left")
      nmap("<Leader>bdl", ":BufferLineCloseRight<CR>", "[BL]: Closes all buffers to the right")
    end,
  },

  { -- Plugin to persist and toggle multiple terminals during an
    -- editing session
    "akinsho/toggleterm.nvim",
    opts = {
      close_on_exit = true,
      direction = "float",
      float_opts = {
        border = "curved",
        width = function()
          return opt.columns:get()
        end,
        height = function()
          local win_height = opt.lines:get() - 3
          -- source: telescope/pickers/layout_strategies.lua
          local tabline = opt.showtabline:get()
          local has_tbln = (tabline == 2) or (tabline == 1 and #api.nvim_list_tabpages() > 1)

          if has_tbln then
            return win_height - 1 -- will not hide the tabline
          else
            return win_height
          end
        end,
      },
      -- whether or not the open mapping applies in insert mode
      insert_mappings = false,
      open_mapping = "<c- >",
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      tmap("<C-ESC>", [[<C-\><C-n>]], "[TT]: Enter normal mode on a terminal window")
    end,
  },

  { -- Neovim file explorer: edit your filesystem like a buffer
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Might try dunno:
  --
  -- TODO(Unavailable): https://github.com/folke/todo-comments.nvim
  -- TODO(Unavailable): https://github.com/folke/persistence.nvim
  -- TODO(Unavailable): https://github.com/echasnovski/mini.nvim
  -- TODO(Unavailable): https://github.com/lewis6991/gitsigns.nvim
  -- TODO(Unavailable): https://github.com/kwkarlwang/bufresize.nvim
}

-- Setup
---@diagnostic disable-next-line: missing-fields
require("lazy").setup({
  -- automatically check for plugin updates
  checker = { enabled = false },
  ---@diagnostic disable-next-line: assign-type-mismatch
  dev = {
    path = fn.stdpath("data") .. "/../../repos/lua",
  },
  install = { missing = true },
  spec = plugins,
})
