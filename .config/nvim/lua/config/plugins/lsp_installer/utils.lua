
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

--[[
FIX: If there is a file with the server name, but no contents in it,
this func will not work. ( I want just to have it in mind. Technically,
people will not create empty files just because. )
--]]
function M.extend_server_config(server_name, opts)
    local configured, server_opts = pcall(require, "config.plugins.lsp_installer.server_config." .. server_name)
    if configured then return vim.tbl_deep_extend("force", server_opts, opts) else return opts end
end

function M.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

return M
