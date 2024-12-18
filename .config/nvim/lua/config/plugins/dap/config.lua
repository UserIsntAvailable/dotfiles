local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end


require("config.keymaps").dap(dap)

local dapui = require("dapui")

-- TODO: Maybe I want to manually open the dapui windows?
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open(nil)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close(nil)
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close(nil)
end
