
local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

treesitter.setup {
    ensure_installed = "all",
    sync_install = false,
    ignore_install = { "phpdoc" },
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    -- TODO: Configure more modules.
}
