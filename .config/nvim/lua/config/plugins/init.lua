require("packer")

local function require_plugin(file_name)
    require("config.plugins." .. file_name)
end

require_plugin("lsp_installer")
require_plugin("treesitter")
require_plugin("luasnip")
require_plugin("cmp")
require_plugin("autopairs")
require_plugin("telescope")
require_plugin("bufferline")
require_plugin("nvim-tree")
require_plugin("toggleterm")
