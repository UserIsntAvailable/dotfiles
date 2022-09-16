require("config.autocmds").lsp_fsharp()

return {
    on_attach = function(client, bufnr)
        -- Hacky way of just ignoring document highlights.
        -- It seems that fsautocomplete doesn't like blank lines :/.
        -- I could modify `lsp_document_highlight`, but I don't want to deal with that.
        -- https://github.com/LunarVim/LunarVim/issues/2903
        client.server_capabilities.documentHighlightProvider = false
        require("config.plugins.lsp.handlers").on_attach(client, bufnr)
    end,
    settings = {
        FSharp = {
            enableAnalyzers = true,
            externalAutocomplete = true,
            smartIndent = true,
        },
    },
}
