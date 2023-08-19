local M = {}

M.tbl_extend = function(this, other)
    for key, value in pairs(other) do
        this[key] = value
    end
end

---Concatenates a list of values by a separator creating a new string.
---@param values any[] the list of values that would be concatenated.
---@param sep? string the separator which the string would be concatenated.
---@return string
M.concat = function(values, sep)
    sep = sep == nil and " " or sep

    local t = {}
    for _, v in ipairs(values) do
        t[#t + 1] = tostring(v)
    end

    return table.concat(t, sep)
end

return M
