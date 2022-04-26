
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local lsp_utils = require("config.plugins.lsp_installer.utils")
local lsp_config = require("config.plugins.lsp_installer.config")

local lsp_servers = lsp_config.language_servers

lsp_utils.download_lsp_servers(lsp_servers)

lsp_installer.on_server_ready(function(server)
    if not lsp_utils.contains(lsp_servers, server.name) then
        return
    end

    local opts = lsp_config.default_server_setup
    opts = lsp_utils.extend_server_config(server.name, opts)
    server:setup(opts)
end)
