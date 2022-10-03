pcall(require, "luarocks.loader")

require("awful.autofocus")

local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")

-- Menubar configuration
menubar.utils.terminal = os.getenv("TERMINAL")

beautiful.init(os.getenv("XDG_CONFIG_HOME") .. "/awesome/" .. "theme.lua")

require("config.error_handler")

require("config.layouts")

require("config.rules")

-- {Key,Mouse}binds
require("config.binds")

require("config.desktop")

awful.spawn("autostart", false)
