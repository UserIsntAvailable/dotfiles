local awful = require("awful")
local mod_key = require("config.variables").mod_key

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate({
                context = "mouse_click",
            })
        end),

        awful.button({ mod_key }, 1, function(c)
            c:activate({
                context = "mouse_click",
                action = "mouse_move",
            })
        end),

        awful.button({ mod_key }, 3, function(c)
            c:activate({
                context = "mouse_click",
                action = "mouse_resize",
            })
        end),
    })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate({
        context = "mouse_enter",
        raise = false,
    })
end)
