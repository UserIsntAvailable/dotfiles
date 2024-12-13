local wezterm = require("wezterm")

-- TODO: https://wezfurlong.org/wezterm/config/lua/config/use_ime.html

return {
    font_size = 18,
    font = wezterm.font("ConsolasLigaturizedV3 Nerd Font"),
    warn_about_missing_glyphs = false,
}
