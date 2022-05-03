
local M = {}

-- TODO: Configure lsp diagnostics.
-- TODO: Automatically source when saving.

-- Language servers protocols that will be installed/started.
-- see here for all the available ones: https://github.com/williamboman/nvim-lsp-installer#available-lsps
M.language_servers = {
    "sumneko_lua"
}

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

-- The default server setup info that all language servers will have.
-- If you wanna tweak a specific server, look into server_config/SERVER_NAME.lua
M.default_server_setup = {
    on_attach = function(client, _)
        require("config.keymaps").lsp_buffer()

        if client.server_capabilities.documentHighlightProvider then
            require("config.autocmds").lsp_document_highlight()
        end
    end,
    capabilities = capabilities
}

return M
