local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd("packadd packer.nvim")
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- stylua: ignore start
return packer.startup(function(use)
    -- essentials
    use "wbthomason/packer.nvim"                        -- Have packer manage itself
    use "nvim-lua/popup.nvim"                           -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"                         -- Useful lua functions used by lots of plugins
    use "kyazdani42/nvim-web-devicons"                  -- API to work with icons easier

    -- colorschemes
    use "rktjmp/lush.nvim"                              -- Colorscheme Maker Helper
    -- call colorscheme + name
    use "metalelf0/jellybeans-nvim"
    use "marko-cerovac/material.nvim"
    use "sainnhe/sonokai"
    use "lourenci/github-colors"
    use "Everblush/everblush.vim"
    -- needs setup
    use "mhartington/oceanic-next"
    use "navarasu/onedark.nvim"                         -- Current Active
    use "adisen99/codeschool.nvim"
    use "projekt0n/github-nvim-theme"
    use "rose-pine/neovim"
    use "adisen99/apprentice.nvim"
    use "phha/zenburn.nvim"

    -- lsp
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"
    use "onsails/lspkind.nvim"
    use "jose-elias-alvarez/null-ls.nvim"
    use "chen244/csharpls-extended-lsp.nvim"
    use "j-hui/fidget.nvim"                             -- Shows lsp progress
    use "jose-elias-alvarez/nvim-lsp-ts-utils"
    use "theHamsta/nvim-semantic-tokens"

    -- treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    -- modules
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "nvim-treesitter/playground"
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use "windwp/nvim-ts-autotag"

    -- snippets
    use "L3MON4D3/LuaSnip"                              -- Snippet Engine
    use "rafamadriz/friendly-snippets"                  -- Collection of snippets

    -- cmp
    use "hrsh7th/nvim-cmp"                              -- Autocomplete plugin
    -- sources from where it can autocomplete
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-calc"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-path"

    use "windwp/nvim-autopairs"

    -- telescope
    use "nvim-telescope/telescope.nvim"
    -- extentions
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use "nvim-telescope/telescope-ui-select.nvim"
    use "LinArcX/telescope-env.nvim"
    use "cljoly/telescope-repo.nvim"
    use "lewis6991/spellsitter.nvim"

    use { "akinsho/bufferline.nvim", tag = "v2.*" }

    use "famiu/bufdelete.nvim"

    use "kyazdani42/nvim-tree.lua"

    use "akinsho/toggleterm.nvim"

    use "numToStr/Comment.nvim"

    use "rcarriga/nvim-notify"

    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
-- stylua: ignore stop
