local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd "packadd packer.nvim"
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init {
    display = {
        open_fn = function() return require("packer.util").float { border = "rounded" } end,
    },
}

return packer.startup(function(use)
    -- Essentials
    use "wbthomason/packer.nvim"    -- Have packer manage itself
    use "nvim-lua/popup.nvim"       -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"     -- Useful lua functions used by lots of plugins

    -- Colorschemes
    use {
        "metalelf0/jellybeans-nvim",
        requires = {"rktjmp/lush.nvim"}
    }

    -- lsp
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"

    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
