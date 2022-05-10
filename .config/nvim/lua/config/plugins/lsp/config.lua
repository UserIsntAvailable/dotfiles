local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
    return
end

-- see here for all the available ones: https://github.com/williamboman/nvim-lsp-installer#available-lsps
local servers = {
    "sumneko_lua"
}

local lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if lsp_installer_ok then lsp_installer.setup({ ensure_installed = servers }) end

-- The default server setup info that all language servers will have.
-- If you wanna tweak a specific server, look into server_config/SERVER_NAME.lua
local default_server_setup = {
    on_attach = function(client, _)
        require("config.keymaps").lsp_buffer()

        if client.server_capabilities.documentHighlightProvider then
            require("config.autocmds").lsp_document_highlight()
        end
    end,
    capabilities = (function()
        local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if status_ok then capabilities = cmp_nvim_lsp.update_capabilities(capabilities) end

        return capabilities
    end)()
}

-- TODO: Configure lsp diagnostics.

for _, server in pairs(servers) do
    local opts = default_server_setup

    local configured, server_opts = pcall(require, "config.plugins.lsp.server_config." .. server)
    if configured then
        opts = vim.tbl_deep_extend("force", server_opts, opts)
    end

    lspconfig[server].setup(opts)
end
