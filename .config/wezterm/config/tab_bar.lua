local wezterm = require("wezterm")
local utils = require("config.utils")

---Removes the 'Copy Mode' notice
---@param title string
---@return string
local function remove_copy_mode(title)
    return select(1, string.gsub(title, "Copy mode: ", "[c]", 1))
end

wezterm.on(
    "format-tab-title",
    ---@diagnostic disable-next-line: unused-local
    function(tab, tabs, panes, config, hover, max_width)
        local idx = tab.tab_index
        local title = remove_copy_mode(tab.active_pane.title)
        return utils.concat({ " ", idx, ": ", title, " " }, "")
    end
)

return {
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    show_new_tab_button_in_tab_bar = false,
    switch_to_last_active_tab_when_closing_tab = true,
    tab_and_split_indices_are_zero_based = true,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
}
