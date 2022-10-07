return {
    on_attach = function(client, buf)
        require("config.plugins.lsp.handlers").on_attach(client, buf)

        -- Needs PR: https://github.com/neovim/neovim/pull/15723
        if client.server_capabilities.semanticTokensProvider then
            require("nvim-semantic-tokens").setup({ preset = "default" })

            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                pattern = "<buffer>",
                callback = function()
                    vim.lsp.buf.semantic_tokens_full()
                end,
                group = vim.api.nvim_create_augroup("SemanticHighlights", { clear = true }),
                desc = "Semantic Highlights",
            })
        end
    end,
    cmd = {
        -- This is my own compiled version of `csharp-language-server` I will try to merge `upstream`
        -- it when I find the motivation to finished it. You can take a look at:
        -- https://github.com/UserIsntAvailable/csharp-language-server in `semantic-tokens` branch.
        vim.fn.expand(
            "~/.local/repos/fsharp/csharp-language-server/src/CSharpLanguageServer/bin/Release/net6.0/CSharpLanguageServer"
        ),
    },
    handlers = {
        ["textDocument/definition"] = require("csharpls_extended").handler,
        ["window/showMessage"] = function(_, method, params, _)
            if method.message:sub(12, 13) ~= "OK" then
                return
            end

            vim.notify(
                method.message:sub(15),
                vim.log.levels[params.type],
                { title = "Csharp-LS" }
            )
        end,
    },
    flags = {
        -- Without this, the language server is unusable
        update_in_insert = true,
        debounce_text_changes = 0,
    },
}
