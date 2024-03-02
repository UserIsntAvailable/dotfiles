local M = {}

-- TODO: Configure diagnostics.
-- TODO: Configure codelens.

M.on_attach = function(client, _)
    require("config.keymaps").lsp_buffer()
end

return M
