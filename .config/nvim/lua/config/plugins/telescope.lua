local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

telescope.setup({
    defaults = {
        mappings = require("config.keymaps").telescope(),
    },
    pickers = {
        find_files = { previewer = false },
        live_grep = { layout_strategy = "vertical" },
        grep_string = { layout_strategy = "vertical" },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
    },
})

require("config.keymaps").telescope_pickers(require("telescope.builtin"))

-- extensions --

telescope.load_extension("env")
telescope.load_extension("fzf")
telescope.load_extension("notify")
telescope.load_extension("repo")
telescope.load_extension("ui-select")
