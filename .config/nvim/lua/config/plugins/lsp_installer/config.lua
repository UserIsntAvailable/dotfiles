
local M = {}

-- TODO: Configure lsp diagnostics.

-- Language servers protocols that will be installed/activated.
-- see here for all the available ones: https://github.com/williamboman/nvim-lsp-installer#available-lsps
M.language_servers = { -- TODO: If server if not on the list, but it is installed, don't call their setup method.
    "sumneko_lua"
}

-- The default server setup info that all language servers will have.
-- If you wanna tweak a specific server look into server_config/SERVER_NAME.lua
M.default_server_setup = {
    on_attach = function(client, bufnr)
        require("config.keymaps").lsp_buffer_keymaps()
        -- TODO: add some default server_capabilities.
    end
}

return M
