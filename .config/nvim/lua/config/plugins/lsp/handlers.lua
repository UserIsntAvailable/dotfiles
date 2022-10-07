local M = {}

-- TODO: Configure diagnostics.
-- TODO: Configure codelens.

M.on_attach = function(client, _)
    require("config.keymaps").lsp_buffer()

    if client.server_capabilities.documentHighlightProvider then
        require("config.autocmds").lsp_document_highlight()
    end
end

return M
