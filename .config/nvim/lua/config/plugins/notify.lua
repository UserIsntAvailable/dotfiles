local status_ok, notify = pcall(require, "notify")
if not status_ok then
    return
end

notify.setup({
    background_colour = require("dotscode.colors").vscBack,
    render = "simple",
    stages = "fade",
    top_down = true,
})

vim.notify = notify
