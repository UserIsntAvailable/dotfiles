local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end

comment.setup({
    pre_hook = function(ctx)
        -- Only calculate commentstring for tsx filetypes
        if vim.bo.filetype == "typescriptreact" then
            local U = require("Comment.utils")

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.block then
                location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring({
                key = type,
                location = location,
            })
        end
    end,
    -- Adds "\n" on multi-line block comments ( https://github.com/numToStr/Comment.nvim/issues/38#issuecomment-945082507 )
    post_hook = function(ctx)
        if
            vim.bo.filetype ~= "lua"
            or ctx.range.srow == -1
            or ctx.range.srow == ctx.range.erow
            or ctx.ctype == 1
        then
            return
        end

        local cfg = require("Comment.config"):get()
        local comment_utils = require("Comment.utils")

        local cstr = require("Comment.ft").get(vim.bo.filetype, ctx.ctype)
        local lcs, rcs = comment_utils.unwrap_cstr(cstr)
        local padding = comment_utils.get_padding(cfg.padding)
        local lines = vim.api.nvim_buf_get_lines(0, ctx.range.srow - 1, ctx.range.erow, false)

        if ctx.cmode == 1 then -- comment
            local str = lines[1]
            lcs = string.gsub(lcs, "%[", "%%[") -- lcs needs to be escaped to work inside find
            local i, j = string.find(str, lcs .. padding)
            lines[1] = string.sub(str, i, j - #padding)
            table.insert(lines, 2, string.sub(str, 0, i - 1) .. string.sub(str, j + #padding, #str))

            str = lines[#lines]
            i, j = string.find(str, rcs)
            lines[#lines] = string.sub(str, 0, i - #padding - 1)
            table.insert(lines, #lines + 1, string.sub(str, i, j))
        elseif ctx.cmode == 2 then -- uncomment
            if #lines[1] == 0 and #lines[#lines] == 0 then
                table.remove(lines, 1)
                table.remove(lines, #lines)
            end
        end

        vim.api.nvim_buf_set_lines(0, ctx.range.srow - 1, ctx.range.erow, false, lines)
    end,
})