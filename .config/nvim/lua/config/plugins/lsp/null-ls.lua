local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

local nls_extra_folder_path = vim.fn.stdpath("config") .. "/extra/null-ls/"

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local sources = {
    formatting = {
        stylua = { extra_args = { "--config-path", nls_extra_folder_path .. "stylua.toml" } },
        shfmt = { extra_args = { "-i", 4, "-ci", "-sr" } },
    },
}

local sources_modules = {}

-- Checks if tools are properly installed on the system.
-- and add then to sources_modules.
for source_section, source_section_table in pairs(sources) do
    for source, source_table in pairs(source_section_table) do
        if vim.fn.executable(source) == 1 then
            table.insert(
                sources_modules,
                null_ls.builtins[source_section][source].with(source_table)
            )
        else
            -- TODO: Be able to disable print
            print("[null-ls]: " .. source .. " was not found on the system. ( skipping )")
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
