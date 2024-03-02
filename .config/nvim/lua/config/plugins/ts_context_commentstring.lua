local status_ok, tsctxcs = pcall(require, "ts_context_commentstring")
if not status_ok then
    return
end

tsctxcs.setup({
    enable_autocmd = false,
})
