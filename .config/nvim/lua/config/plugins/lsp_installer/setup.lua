
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local lsp_utils = require("config.plugins.lsp_installer.utils")
local lsp_config = require("config.plugins.lsp_installer.config")

lsp_utils.download_lsp_servers(lsp_config.language_servers)

lsp_installer.on_server_ready(function(server)
    local opts = lsp_config.default_options
    server:setup(opts)
end)
