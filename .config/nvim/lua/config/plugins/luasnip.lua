
local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

require("luasnip/loaders/from_vscode").lazy_load()

ls.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
}

require("config.keymaps").luasnip_keymaps(ls)