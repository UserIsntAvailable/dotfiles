
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local conf_variables = require("config.variables")
local mod_key = conf_variables.mod_key
local terminal = conf_variables.terminal


-- General
awful.keyboard.append_global_keybindings({
    awful.key(
        {mod_key, "Control"}, "h",
        hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}
    ),
    awful.key(
        {mod_key, "Control"}, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),
    awful.key(
        {mod_key, "Control"}, "q",
        awesome.quit,
        {description = "quit awesome", group = "awesome"}
    ),
})

-- Launchers related
awful.keyboard.append_global_keybindings({
    awful.key(
        {mod_key}, "Return",
        function() awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}
    ),
    awful.key(
        {mod_key}, "b",
        function() awful.spawn("firefox") end,
        {description = "run browser", "launcher"}
    ),
    awful.key(
        {mod_key}, "r",
        function() awful.spawn("rofi -show drun -theme dots-dmenu -modi drun -drun-display-format {name}") end,
        {description = "run prompt", group = "launcher"}
    ),
    awful.key(
        {mod_key}, "s",
        function() awful.spawn("flameshot screen -c") end,
        {description = "makes an screenshot of the monitor that is active", group = "launcher"}
    ),
    awful.key(
        {mod_key, "Shift"}, "s",
        function() awful.spawn("flameshot gui") end,
        {description = "run a screenshot tool", group = "launcher"}
    )
})

-- Tags related
awful.keyboard.append_global_keybindings({
    awful.key(
        {mod_key}, "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}
    ),
    awful.key(
        {mod_key}, "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}
    ),
    awful.key(
        {mod_key}, "`",
        awful.tag.history.restore,
        {description = "go back", group = "tag"}
    )
})

-- Focus related
awful.keyboard.append_global_keybindings({
    awful.key(
        {mod_key}, "j",
        function() awful.client.focus.byidx(1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {mod_key}, "k",
        function() awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key(
        {mod_key}, "Tab",
        function()
            awful.client.focus.history.previous();
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),
    awful.key(
        {mod_key, "Control"}, "j",
        function() awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}
    ),
    awful.key(
        {mod_key, "Control"}, "k",
        function() awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}
    ),
    awful.key(
        {mod_key, "Control"}, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate{
                    raise = true,
                    context = "key.unminimize"
                }
            end
        end,
        {description = "restore minimized", group = "client"}
    )
})

-- Layout related
awful.keyboard.append_global_keybindings({
    awful.key(
        {mod_key}, "u",
        awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}
    ),
    awful.key(
        {mod_key}, "l",
        function() awful.tag.incmwfact(0.05) end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {mod_key}, "h",
        function() awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {mod_key}, "space",
        function() awful.layout.inc(1) end,
        {description = "select next", group = "layout"}
    ),
    awful.key(
        {mod_key, "Shift"}, "j",
        function() awful.client.swap.byidx(1) end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {mod_key, "Shift"}, "k",
        function() awful.client.swap.byidx(-1) end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {mod_key, "Shift"},"h",
        function() awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {mod_key, "Shift"}, "l",
        function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {mod_key, "Shift"}, "space",
        function() awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}
    ),
    awful.key(
        {mod_key, "Control"}, "h",
        function() awful.tag.incncol(1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}
    ),
    awful.key(
        {mod_key, "Control"}, "l",
        function() awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}
    )
})

-- Tags related
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers = {mod_key}, keygroup = "numrow",
        description = "only view tag", group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:view_only() end
        end
    },
    awful.key {
        modifiers = {mod_key, "Control"}, keygroup = "numrow",
        description = "toggle tag", group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then awful.tag.viewtoggle(tag) end
        end
    },
    awful.key {
        modifiers = {mod_key, "Shift"}, keygroup = "numrow",
        description = "move focused client to tag", group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:move_to_tag(tag) end
            end
        end
    },
    awful.key {
        modifiers = {mod_key, "Control", "Shift"}, keygroup = "numrow",
        description = "toggle focused client on tag", group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:toggle_tag(tag) end
            end
        end
    },
    awful.key {
         modifiers = {mod_key}, keygroup = "numpad",
         description = "select layout directly", group = "layout",
         on_press = function(index)
            local t = awful.screen.focused().selected_tag
            if t then t.layout = t.layouts[index] or t.layout end
         end
    }
})
