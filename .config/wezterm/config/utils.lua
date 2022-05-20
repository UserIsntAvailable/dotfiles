local M = {}

M.tbl_extend = function(this, other)
    for key, value in pairs(other) do
        this[key] = value
    end
end

return M
