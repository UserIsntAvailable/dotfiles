local theme_assets = require("beautiful.theme_assets")
local rnotification = require("ruled.notification")
local dpi = require("beautiful.xresources").apply_dpi
local themes_path = require("gears.filesystem").get_themes_dir()

local theme = {}

theme.font = "mono 10"

theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = 3
theme.border_width = 2
theme.border_color_normal = "#000000"
theme.border_color_active = "#ff4f58"

theme.titlebar_border_width = 2
theme.border_color1_normal = "#000000"
theme.border_color2_normal = "#000000"
-- TODO: Automatically get gradient colors from the current background
theme.border_color1_active = "#FF002F"
theme.border_color2_active = "#00AEFF"

theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"

theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

rnotification.connect_signal("request::rules", function()
    rnotification.append_rule({
        rule = { urgency = "critical" },
        properties = { bg = "#ff0000", fg = "#ffffff" },
    })
end)

return theme
