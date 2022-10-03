local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

local null_ls_extra_folder_path = vim.fn.stdpath("config") .. "/extra/null-ls/"

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md

-- TODO: Instead of having lsp configuration and null-ls configuration I should
-- probably create lsp configuration per language. So all configuration of
-- python ( pylsp, flake8, mypy, pylink, and black ) should be at python.lua

local MAX_LINE_LENGTH = 100
-- local VIRTUAL_ENV = "$VIRTUAL_ENV"
-- local VENV_SITE_PACKAGES_PATH = (function() -- FIX: There is probably an easier way to do this.
--     local venv = vim.fn.expand(VIRTUAL_ENV)
--
--     if venv == VIRTUAL_ENV then
--         -- TODO: Automatically activate the virtual env.
--         return vim.schedule(function()
--             vim.notify("Don't forget to enter the virtual environment.", vim.log.levels.ERROR)
--         end)
--     end
--
--     local python_path = require("plenary.scandir").scan_dir(
--         venv .. "/lib",
--         { depth = 1, add_dirs = true, only_dirs = true }
--     )[1]
--
--     return python_path .. "/site-packages"
-- end)() or ""

local sources = {
    code_actions = {
        shellcheck = {},
    },
    diagnostics = {
        flake8 = { extra_args = { "--max-line-length", MAX_LINE_LENGTH } },
        mypy = {
            env = nil,--[[ { MYPYPATH = VENV_SITE_PACKAGES_PATH } ]]
        },
        pylint = {
            extra_args = { "--max-line-length", MAX_LINE_LENGTH, "--disable", "C0111" },
            -- env = {
            --     -- stylua: ignore
            --     PYTHONPATH = VENV_SITE_PACKAGES_PATH
            --         .. (jit.os == "Windows" and ";" or ":")
            --         .. vim.fn.fnamemodify(VIRTUAL_ENV, ":p:h") .. "/src",
            -- },
        },
        shellcheck = {},
    },
    formatting = {
        black = { extra_args = { "--preview", "-l", MAX_LINE_LENGTH } },
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
        end
    end
end

-- TODO: Open `null-ls` checkhealth in another buffer. If any source is missing.

null_ls.setup({
    default_timeout = 2000, -- I will tweeak by source/project if needed.
    diagnostics_format = "[#{c}]: #{m}",
    on_attach = require("config.plugins.lsp.handlers").on_attach,
    sources = sources_modules,
    -- update_in_insert = false, -- TODO: Test performance
})
