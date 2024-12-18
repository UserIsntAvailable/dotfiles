local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

local u = require("config.plugins.lsp.utils")
local path = require("null-ls.utils").path

local fs = vim.fs
local get_config_args = u.get_config_args
local default = u.get_default_config

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md

-- TODO: Instead of having lsp configuration and null-ls configuration I should
-- probably create lsp configurations per language. So all configuration of
-- python ( pylsp, flake8, mypy, pylink, and black ) should be at python.lua

local MAX_LINE_LENGTH = 100
local SITE_PACKAGES = (function()
    local virtual_env = "$VIRTUAL_ENV/lib"
    local lib_dir = fs.normalize(virtual_env)

    -- virtual env is not activated
    if lib_dir == virtual_env then
        return nil
    end

    local site_packages = "site-packages"
    return fs.find({ site_packages }, { path = lib_dir, stop = site_packages, type = "directory" })[1]
end)()

local sources = {
    code_actions = { shellcheck = {} },
    diagnostics = {
        flake8 = {
            extra_args = get_config_args(
                "--config",
                { ".flake8", "setup.cfg", "tox.ini" },
                { "--max-line-length", MAX_LINE_LENGTH }
            ),
        },
        mypy = {
            -- TODO: Cache
            env = function()
                if SITE_PACKAGES then
                    return { MYPYPATH = SITE_PACKAGES }
                end

                vim.notify(
                -- TODO: Activate automatically virt env if there is actually one in the `root`
                -- dir.
                    "Virtual Environment is not activated",
                    vim.log.levels.WARN,
                    { title = "Null-LS - MYPY" }
                )
            end,
        },
        pylint = {
            -- TODO: Cache
            env = function(params)
                local root = params.root
                local locations = { root, path.join(root, "src") }

                if SITE_PACKAGES then
                    locations = vim.list_extend({ SITE_PACKAGES }, locations)
                end

                return { PYTHONPATH = table.concat(locations, (jit.os == "Windows" and ";" or ":")) }
            end,
            extra_args = { "--max-line-length", MAX_LINE_LENGTH, "--disable", "C0111" },
        },
        selene = {
            extra_args = { "--config", "$ROOT/selene.toml" },
            condition = function(utils)
                return utils.root_has_file({ "selene.toml" })
            end,
        },
        shellcheck = {},
    },
    formatting = {
        black = {
            extra_args = get_config_args(
                "--config",
                "pyproject.toml",
                { "--preview", "-l", MAX_LINE_LENGTH }
            ),
        },
        clang_format = {},
        -- TODO: Create default config.
        cbfmt = { extra_args = get_config_args("--config", ".cbfmt.toml", {}) },
        shfmt = {
            extra_args = {
                "--indent",
                4,
                "--binary-next-line",
                "--case-indent",
                "--func-next-line",
            },
        },
        stylua = {
            extra_args = get_config_args(
                "--config-path",
                { "stylua.toml", ".stylua.toml" },
                default
            ),
        },
        prettier = {
            extra_args = get_config_args(
                "--config",
                -- TODO: Add all possible possibilities.
                { "prettier.config.mjs" },
                {}
            ),
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

-- TODO: Open `null-ls` checkhealth in another buffer, if any source is missing.

null_ls.setup({
    default_timeout = 2000, -- I will tweeak by source/project if needed.
    diagnostics_format = "[#{c}]: #{m}",
    on_attach = require("config.plugins.lsp.handlers").on_attach,
    -- TODO: root_dir
    sources = sources_modules,
    -- update_in_insert = false, -- TODO: Test performance
})
