local utils = require("config.utils")

local config = { check_for_updates = false }

utils.tbl_extend(config, require("config.colors"))
utils.tbl_extend(config, require("config.font"))
utils.tbl_extend(config, require("config.keybinds"))
utils.tbl_extend(config, require("config.window"))

return config
