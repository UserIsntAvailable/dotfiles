
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
    return
end

local lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not lsp_installer_ok then
    return
end

-- utils --

--[[
    FIX: If there is a file with the server name, but no contents in it,
    this func will not work. ( I want just to have it in mind. Technically,
    people will not create empty files just because. )
--]]
local function extend_server_config(server_name, opts)
    local configured, server_opts = pcall(require, "config.plugins.lsp_installer.server_config." .. server_name)
    if configured then return vim.tbl_deep_extend("force", server_opts, opts) else return opts end
end

-- setup --

local lsp_config = require("config.plugins.lsp_installer.config")
local servers = lsp_config.language_servers

lsp_installer.setup({
    ensure_installed = servers
})

for _, server in pairs(servers) do
    local opts = lsp_config.default_server_setup
    opts = extend_server_config(server, opts)
	lspconfig[server].setup(opts)
end
