local wezterm = require("wezterm")

local function map(mods, key, action)
    return {
        mods = mods,
        key = key,
        action = type(action) ~= "string" and wezterm.action(action) or action,
    }
end

-- TODO: Look into: https://wezfurlong.org/wezterm/config/lua/keyassignment/AttachDomain.html

local keys = {
    map("CTRL|SHIFT", "c", { CopyTo = "Clipboard" }),
    map("CTRL|SHIFT", "v", { PasteFrom = "Clipboard" }),

    map("ALT", "b", { SpawnCommandInNewTab = { cwd = "~" } }),
    map("ALT", "l", "ShowDebugOverlay"),
    map("ALT", "r", "ReloadConfiguration"),
    map("ALT", "s", "QuickSelect"),
    map("ALT", "w", { CloseCurrentTab = { confirm = false } }),
    map("ALT", "Escape", "ActivateCopyMode"),
    map("ALT", "Tab", "ActivateLastTab"),

    map("CTRL", "-", "DecreaseFontSize"),
    map("CTRL", "=", "IncreaseFontSize"),
    map("CTRL", "0", "ResetFontSize"),
}

for idx = 1, 10 do
    local idx_zero_based = idx - 1
    table.insert(
        keys,
        map(
            "ALT",
            tostring(idx_zero_based),
            { ActivateTab = idx_zero_based }
        )
    )
end

return {
    disable_default_key_bindings = true,
    keys = keys,
    quick_select_patterns = {
        -- matches rust attributes ( derives, features, lint levels, etc... )
        "#!?\\[.*\\(.*,*.*\\)\\]"
    },
}
