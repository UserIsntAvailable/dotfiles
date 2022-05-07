local bl_ok, bufferline = pcall(require, "bufferline")
if not bl_ok then
    return
end

local bd_ok, bufdelete = pcall(require, "bufdelete")
if not bd_ok then
    return
end

-- utils --

-- FIX: I think that NvimTree and bufferline do not like each other

-- local function buf_close_handler(bufnum)
-- bufdelete.bufdelete(bufnum, true)
-- end

local function remove_buf_extension(buf)
    return vim.fn.fnamemodify(buf.name, ':t:r')
end

local function format_lsp_indications(count --[[ level ]] --[[ diagnostics_dict ]] --[[ context ]])
    return "(" .. count .. ")"
end

-- setup --

bufferline.setup {
    options = {
        -- close_command = buf_close_handler,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = format_lsp_indications,
        diagnostics_update_in_insert = false,
        max_name_length = 25,
        mode = "buffers",
        modified_icon = "",
        name_formatter = remove_buf_extension,
        numbers = "none",
        persist_buffer_sort = true,
        separator_style = "thin",
        show_buffer_close_icons = false,
        show_close_icon = false,
        sort_by = "insert_at_end",
        tab_size = 1,
        offsets = { { filetype = "NvimTree", text = "NvimTree", text_align = "center" } },
        groups = { items = { require("bufferline.groups").builtin.pinned:with({ icon = "" }), } }
    },
}

-- require("config.keymaps").bufdelete(bufdelete) -- I will keep this here, since creating a file for only keymaps would be silly.
vim.keymap.set("n", "<Leader>bdd", ":bdelete %<CR>", { silent = true, desc = "Close a buffer" }) -- Keeping this for now
require("config.keymaps").bufferline()
