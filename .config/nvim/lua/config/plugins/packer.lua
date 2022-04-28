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
    -- essentials
    use "wbthomason/packer.nvim"        -- Have packer manage itself
    use "nvim-lua/popup.nvim"           -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"         -- Useful lua functions used by lots of plugins

    -- colorschemes
    use {
        "metalelf0/jellybeans-nvim",
        requires = {"rktjmp/lush.nvim"}
    }

    -- lsp
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"
    use "onsails/lspkind.nvim"

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    -- snippets
    use "L3MON4D3/LuaSnip"              -- Snippet Engine
    use "rafamadriz/friendly-snippets"  -- Collection of snippets

    -- cmp
    use "hrsh7th/nvim-cmp"              -- The actual plugin
    use "saadparwaiz1/cmp_luasnip"      -- To use LuaSnip as Snippet Engine
    -- sources
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-calc"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"

    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
