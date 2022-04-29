
--[[
TODO: Actually understand what this is doing.
The config example from here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
is not working correctly, but this https://github.com/LunarVim/Neovim-from-scratch/blob/06-LSP/lua/user/lsp/settings/sumneko_lua.lua
is fine, so I will be using that for the moment.
--]]
return {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
}
