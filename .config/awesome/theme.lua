local theme_assets = require("beautiful.theme_assets")
local rnotification = require("ruled.notification")
local dpi = require("beautiful.xresources").apply_dpi
local themes_path = require("gears.filesystem").get_themes_dir()

local beautiful = {}

local font_name = "mono "
local white_color = "#FFFFFF"
local bg_color = "#151515"

beautiful.font = font_name .. "10"

beautiful.bg_focus = "#535D6C"
beautiful.bg_urgent = "#FF0000"
beautiful.bg_minimize = "#444444"
beautiful.bg_systray = beautiful.bg_normal

beautiful.fg_normal = "#aaaaaa"
beautiful.fg_focus = white_color
beautiful.fg_urgent = white_color
beautiful.fg_minimize = white_color

beautiful.useless_gap = 3
beautiful.border_width = 2
beautiful.border_color_normal = "#000000"
beautiful.border_color_active = "#FF4F58"

beautiful.titlebar_border_width = 2
beautiful.border_color1_normal = "#000000"
beautiful.border_color2_normal = "#000000"
-- TODO: Automatically get gradient colors from the current background
beautiful.border_color1_active = "#FF002F"
beautiful.border_color2_active = "#00AEFF"

beautiful.menu_submenu_icon = themes_path .. "default/submenu.png"
beautiful.menu_height = dpi(15)
beautiful.menu_width = dpi(100)

beautiful.layout_floating = themes_path .. "default/layouts/floatingw.png"
beautiful.layout_tile = themes_path .. "default/layouts/tilew.png"

beautiful.awesome_icon =
    theme_assets.awesome_icon(beautiful.menu_height, beautiful.bg_focus, beautiful.fg_focus)

beautiful.notification_font = font_name .. "12"
beautiful.notification_bg = bg_color
beautiful.notification_fg = white_color
beautiful.notification_border_color = white_color
beautiful.notification_icon_size = 72

beautiful.hotkeys_bg = bg_color
beautiful.hotkeys_fg = white_color
beautiful.hotkeys_border_width = beautiful.border_width
beautiful.hotkeys_border_color = white_color
beautiful.hotkeys_font = font_name .. "12"
beautiful.hotkeys_description_font = font_name .. "10"
beautiful.hotkeys_group_margin = 5

rnotification.connect_signal("request::rules", function()
    rnotification.append_rule({
        rule = { urgency = "critical" },
        properties = { bg = "#ff0000", fg = "#ffffff" },
    })
end)

return beautiful
