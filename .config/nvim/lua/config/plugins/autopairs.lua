
local npairs_status_ok, npairs = pcall(require, "nvim-autopairs")
if not npairs_status_ok then
    return
end

-- setup --

npairs.setup({
    check_ts = true,
    ts_config = {
        lua = { "string" }, -- it will not add a pair on that treesitter node
    },
    map_c_w = true,
    enable_check_bracket_line = false,
})

-- cmp integration --

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
    cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
            map_char = { tex = "" }
        })
    )
end

-- rules --

local rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

--[[
Add spaces between parentheses
------------------------------
Before 	    Insert 	     After
(|)         space 	     ( | )
( | )         )          ( )|
--]]
npairs.add_rules {
    rule(" ", " ")
        :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        end),
    rule("( ", " )")
        :with_pair(function() return false end)
        :with_move(function(opts)
            return opts.prev_char:match(".%)") ~= nil
        end)
        :use_key(")"),
    rule("{ ", " }")
        :with_pair(function() return false end)
        :with_move(function(opts)
            return opts.prev_char:match(".%}") ~= nil
        end)
        :use_key("}"),
    rule("[ ", " ]")
        :with_pair(function() return false end)
        :with_move(function(opts)
            return opts.prev_char:match(".%]") ~= nil
        end)
        :use_key("]")
}
