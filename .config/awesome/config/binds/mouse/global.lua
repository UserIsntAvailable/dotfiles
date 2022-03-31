
local awful = require("awful")


awful.mouse.append_global_mousebindings({
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext)
})
