local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

local null_ls_extra_folder_path = vim.fn.stdpath("config") .. "/extra/null-ls/"

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local sources = {
    diagnostics = {
        flake8 = { extra_args = { "--max-line-length", 100 } },
        mypy = {},
        pylint = {},
    },
    formatting = {
        black = { extra_args = { "--preview", "-l", 100 } },
        shfmt = { extra_args = { "-i", 4, "-ci", "-sr", "-fn" } },
        stylua = {
            extra_args = function(params)
                local config_name = "stylua.toml"
                local config_path = null_ls_extra_folder_path .. config_name

                -- TODO: Search manually if there are any available stylua.toml till root.
                -- TODO: Cache the stylua.toml path if already used.
                local root_path = params.root .. "/" .. config_name
                if vim.fn.filereadable(root_path) == 1 then
                    config_path = root_path
                end

                return { "--config-path", config_path }
            end,
        },
    },
}

local sources_modules = {}

-- Checks if tools are properly installed on the system,
-- and then, add them to sources_modules.
for source_section, source_section_table in pairs(sources) do
    for source, source_table in pairs(source_section_table) do
        if vim.fn.executable(source) == 1 then
            table.insert(
                sources_modules,
                null_ls.builtins[source_section][source].with(source_table)
            )
        else
            -- Open `null-ls` checkhealth in another buffer.
        end
    end
end

null_ls.setup({
    default_timeout = 2000, -- I will tweeak by source/project if needed.
    diagnostics_format = "[#{c}]: #{m}",
    on_attach = require("config.plugins.lsp.handlers").on_attach,
    sources = sources_modules,
    -- update_in_insert = false, -- TODO: Test performance
})
