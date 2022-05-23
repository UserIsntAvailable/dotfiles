local M = {}

-- TODO: Configure diagnostics.
-- TODO: Configure codelens.

M.on_attach = function(client, _)
    require("config.keymaps").lsp_buffer()

    if client.server_capabilities.documentHighlightProvider then
        require("config.autocmds").lsp_document_highlight()
    end
end

vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
    if string.sub(method.message, 0, 9) == "csharp-ls" then
        if string.sub(method.message, 12, 13) ~= "OK" then
            return
        end
    end
    vim.notify(method.message, ({ "ERROR", "WARN", "INFO", "DEBUG" })[params.type])
end

return M
