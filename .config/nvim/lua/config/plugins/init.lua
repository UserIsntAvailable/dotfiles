
require("packer")

local function require_plugin(file_name)
    local lua_path = "config.plugins."
    require(lua_path .. file_name)
end

require_plugin("lsp_installer")
require_plugin("treesitter")
require_plugin("luasnip")
require_plugin("cmp")
require_plugin("autopairs")
require_plugin("telescope")
require_plugin("bufferline")
