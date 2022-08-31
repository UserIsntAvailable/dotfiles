
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local ls_status_ok, luasnip = pcall(require, "luasnip")
if not ls_status_ok then
    return
end

local lspk_status_ok, lspkind = pcall(require, "lspkind")
if not lspk_status_ok then
    return
end

-- TODO: Change complete menu highlights
cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = require("config.keymaps").cmp(cmp),
    sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
        { name = "calc" },
    }),
    formatting = {
        format = lspkind.cmp_format {
            -- You need a nerd font to see the icons. ( You can disable then with mode = text )
            with_text = true,
            menu = {
                nvim_lua = "[api]",
                nvim_lsp = "[lsp]",
                luasnip = "[snip]",
                path = "[path]",
                buffer = "[buf]",
                calc = "[math]",
            },
        }
    },
    experimental = {
        ghost_text = true,
        native_menu = false
    }
})

cmp.setup.cmdline(":", {
    sources = {
        { name = "cmdline" }
    },
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = { cmdline = "[cmd]", }
        }
    }
})
