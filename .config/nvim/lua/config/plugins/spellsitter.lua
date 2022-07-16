local status_ok, spellsitter = pcall(require, "spellsitter")
if not status_ok then
    return
end

-- TODO: Give a look to: https://github.com/lewis6991/spellsitter.nvim/issues/38
-- I might create a PR, it is the only feature that I'm missing.

spellsitter.setup({
    enable = true,
})
