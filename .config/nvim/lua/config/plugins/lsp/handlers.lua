local M = {}

-- TODO: Configure diagnostics.
-- TODO: Configure codelens.

M.on_attach = function(client, bufnr)
    require("config.keymaps").lsp_buffer()

    if client.server_capabilities.documentHighlightProvider then
        require("config.autocmds").lsp_document_highlight()
    end

    -- if client.server_capabilities.signatureHelpProvider then
    --     require("lsp_signature").attach(client, bufnr)
    -- end
end

return M
