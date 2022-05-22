local status_ok, fidget = pcall(require, "fidget")
if not status_ok then
    return
end

fidget.setup({
    text = {
        spinner = "moon",
        done = " ",
    },
    timer = {
        spinner_rate = 200,
        task_decay = 2000,
    },
    window = {
        relative = "editor",
        blend = 0,
    },
    fmt = {
        leftpad = true,
        stack_upwards = true,
        max_width = 0,
        -- function to format each task line
        task = function(task_name, message, percentage)
            return string.format(
                "%s%s [%s]",
                message,
                percentage and string.format(" (%s%%)", percentage) or "",
                task_name
            )
        end,
    },
})
