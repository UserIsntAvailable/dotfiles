local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
    return
end

-- optional lsp extensions --

local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local lsp_inst_ok, lsp_installer = pcall(require, "nvim-lsp-installer")

-- server config --

local servers = { -- TODO: Maybe I should put all server config files here?
    "sumneko_lua",
    "csharp_ls",
}

if lsp_inst_ok then
    -- All the available language servers: https://github.com/williamboman/nvim-lsp-installer#available-lsps
    lsp_installer.setup({ ensure_installed = servers })
end

-- If you wanna tweak a specific server, look into server_config/SERVER_NAME.lua
local default_server_setup = {
    on_attach = require("config.plugins.lsp.handlers").on_attack,
    capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if cmp_ok then
            capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
        end
        return capabilities
    end)(),
}

-- lsp setup --

for _, server in pairs(servers) do
    local opts = default_server_setup
    local configured, server_opts = pcall(require, "config.plugins.lsp.server_config." .. server)

    if configured then
        opts = vim.tbl_deep_extend("force", server_opts, opts)
    end

    lspconfig[server].setup(opts)
end
