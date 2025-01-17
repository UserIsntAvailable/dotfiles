pcall(require, "luarocks.loader")

require("awful.autofocus")

local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")

-- Menubar configuration
menubar.utils.terminal = os.getenv("TERMINAL")

local xdg_config = os.getenv("XDG_CONFIG_HOME")

beautiful.init(xdg_config .. "/awesome/theme.lua")

require("config.error_handler")

require("config.layouts")

require("config.rules")

-- {Key,Mouse}binds
require("config.binds")

require("config.desktop")

awful.spawn(xdg_config .. "/X11/autostart", false)
