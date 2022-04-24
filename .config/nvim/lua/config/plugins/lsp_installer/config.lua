
local M = {}

-- Language servers protocols that will be installed by default.
-- see here for all the available ones: https://github.com/williamboman/nvim-lsp-installer#available-lsps
M.language_servers = {
}

-- The default options that all language servers will have in common.
-- If you wanna tweak a specific ls look into server_config/handler.lua
M.default_options = {
}

return M
