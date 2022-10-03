local awful = require("awful")
local beautiful = require("beautiful")

-- Desktop Customization
screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
end)

-- Titlebar Customization
-- client.connect_signal(
--     "request::titlebars",
--     function(c) -- Hacky way of having gradiant borders ( Actually recommended by Awesome team )
--         local col1_normal = beautiful.border_color1_normal
--         local col2_normal = beautiful.border_color2_normal
--         local col1_active = beautiful.border_color1_active
--         local col2_active = beautiful.border_color2_active
--         local width = beautiful.titlebar_border_width
--
--         local grad_normal = {
--             type = "linear",
--             from = { 0, 0 },
--             to = { 0, c:geometry().height },
--             stops = { { 0, col1_normal }, { 1, col2_normal } },
--         }
--         local grad_active = {
--             type = "linear",
--             from = { 0, 0 },
--             to = { 0, c:geometry().height },
--             stops = { { 0, col1_active }, { 1, col2_active } },
--         }
--
--         awful.titlebar(c, {
--             position = "top",
--             size = width,
--             bg_normal = col1_normal,
--             bg_focus = col1_active,
--         })
--         awful.titlebar(c, {
--             position = "bottom",
--             size = width,
--             bg_normal = col2_normal,
--             bg_focus = col2_active,
--         })
--         awful.titlebar(c, {
--             position = "left",
--             size = width,
--             bg_normal = grad_normal,
--             bg_focus = grad_active,
--         })
--         awful.titlebar(c, {
--             position = "right",
--             size = width,
--             bg_normal = grad_normal,
--             bg_focus = grad_active,
--         })
--     end
-- )
