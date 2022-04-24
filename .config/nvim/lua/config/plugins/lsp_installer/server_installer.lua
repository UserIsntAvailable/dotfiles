local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

-- Include the language servers you want to have installed by default.
-- see here for the available ones: https://github.com/williamboman/nvim-lsp-installer#available-lsps
local language_servers = {
}

for _, name in pairs(language_servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing: " .. name) -- TODO: nvim.notify instead of print
        server:install()
    end
end
