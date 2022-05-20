local wezterm = require("wezterm")

local function map(mods, key, action)
    return {
        mods = mods,
        key = key,
        action = type(action) ~= "string" and wezterm.action(action) or action,
    }
end

-- TODO: Look into: https://wezfurlong.org/wezterm/config/lua/keyassignment/AttachDomain.html

return {
    disable_default_key_bindings = true,
    keys = {
        map("CTRL|SHIFT", "C", { CopyTo = "Clipboard" }),
        map("CTRL|SHIFT", "V", { PasteFrom = "Clipboard" }),
        map("CTRL|SHIFT", "R", "ReloadConfiguration"),
        map("CTRL|SHIFT", "X", "ActivateCopyMode"),
        map("CTRL|SHIFT", "S", "QuickSelect"),

        map("CTRL", "-", "DecreaseFontSize"),
        map("CTRL", "=", "IncreaseFontSize"),
        map("CTRL", "0", "ResetFontSize"),
    },
}
