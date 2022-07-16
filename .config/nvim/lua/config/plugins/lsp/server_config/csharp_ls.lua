return {
    handlers = {
        ["textDocument/definition"] = require("csharpls_extended").handler,
    },
    flags = {
        -- Without this, the ls is unusable
        update_in_insert = true,
        debounce_text_changes = 0,
    }
}
