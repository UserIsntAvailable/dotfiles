
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local M = {}

function M.download_lsp_servers(server_names)
    for _, server_name in pairs(server_names) do
        local server_is_found, server = lsp_installer.get_server(server_name)
        if server_is_found and not server:is_installed() then
            print("Installing: " .. server_name) -- TODO: nvim.notify
            server:install()
        end
    end
end

return M
