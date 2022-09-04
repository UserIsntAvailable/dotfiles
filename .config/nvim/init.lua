-- Required
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.statusline")
require("config.colorscheme")

-- Everything after this should be wrapped inside a pcallrequire ( or similar
-- mechanism ), in case something is missing.

require("config.plugins")
require("config.external") -- External software
