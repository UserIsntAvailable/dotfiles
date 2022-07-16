local lspc_util = require("lspconfig.util")

-- FIX: The sumneko_lua files are also being loaded

local lua_projects = {
    {
        name = "nvim",
        library = vim.api.nvim_get_runtime_file("", true),
    },
    -- TODO: Find runtime file path
    {
        name = "awesome",
    },
    {
        name = "wezterm",
    },
}

local current_project

local function run_on_project_mode(startpath)
    local config_path = vim.fn.expand("$XDG_CONFIG_HOME/")

    local project_paths = vim.tbl_map(function(project)
        return config_path .. project.name
    end, lua_projects)

    local function match(path)
        for _, project in ipairs(project_paths) do
            if project == path then
                current_project = project
                return path
            end
        end
    end

    return lspc_util.search_ancestors(startpath, match)
end

local function get_project_library(project_path)
    if not project_path then
        return
    end

    local name = vim.fn.fnamemodify(project_path, ":t")
    for _, table in ipairs(lua_projects) do
        if table.name == name then
            return table.library
        end
    end
end

return {
    root_dir = run_on_project_mode,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
    on_init = function(client)
        client.config.settings.Lua.workspace = {
            library = get_project_library(current_project),
        }
        client.notify("workspace/didChangeConfiguration")
        return true
    end,
}
