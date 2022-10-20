-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim

-- For information about installed plugins see the README
--- neovim-lua/README.md
--- https://github.com/brainfucksec/neovim-lua#readme

local cmd = vim.cmd
cmd([[packadd packer.nvim]])

local packer = require('packer')
require('packer.luarocks').setup_paths()

-- Fix Luarocks
-- https://github.com/wbthomason/packer.nvim/issues/180#issuecomment-871634199
vim.fn.setenv('MACOSX_DEPLOYMENT_TARGET', '12.3.1')

-- Add packages
return packer.startup({
  function()
    use('wbthomason/packer.nvim') -- packer can manage itself
    use('nvim-lua/plenary.nvim')
    use_rocks('moses') -- Moses is a utility lib for functional programming in lua

    use('smartpde/debuglog') -- Logging plugin for debugging lua configs

    -- Project Management
    use({
      'Dax89/IDE.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'rcarriga/nvim-notify',
        'stevearc/dressing.nvim',
        'mfussenegger/nvim-dap',
        'rcarriga/nvim-dap-ui',
      },
    })

    -- Pane Management
    use('mrjones2014/smart-splits.nvim')

    -- File explorer
    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
      },
    })
    use('nvim-telescope/telescope-file-browser.nvim')
    -- use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'arch -arm64 make' })
    use('nvim-telescope/telescope-github.nvim')
    use('nvim-telescope/telescope-node-modules.nvim')
    use('nvim-telescope/telescope-ui-select.nvim')
    use('LinArcX/telescope-command-palette.nvim')
    use('gbrlsnchs/telescope-lsp-handlers.nvim')
    use('xiyaowong/telescope-emoji.nvim')
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
      },
    })

    use({
      'nvim-neorg/neorg',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-neorg/neorg-telescope',
      },
    })

    -- Symbol Outline
    use('simrat39/symbols-outline.nvim')

    -- Indentation Guides
    use('lukas-reineke/indent-blankline.nvim')

    -- Which Key
    use('folke/which-key.nvim')

    -- Autopair
    use('windwp/nvim-autopairs')

    -- Pretty Fold
    use('anuvyklack/pretty-fold.nvim')
    use({
      'kevinhwang91/nvim-ufo',
      requires = {
        'kevinhwang91/promise-async',
      },
    })

    -- Icons
    use('kyazdani42/nvim-web-devicons')

    -- Treesitter interface
    use('nvim-treesitter/nvim-treesitter')
    use('nvim-treesitter/playground')
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('nvim-treesitter/nvim-treesitter-context')
    use('RRethy/nvim-treesitter-endwise')
    use({ 'p00f/nvim-ts-rainbow', requires = { 'nvim-treesitter/nvim-treesitter' } })

    -- Color schemes
    use('folke/tokyonight.nvim')
    use('nvchad/nvim-colorizer.lua')

    -- LSP
    use('neovim/nvim-lspconfig')
    use('williamboman/mason.nvim')
    use('williamboman/mason-lspconfig.nvim')
    use('onsails/lspkind-nvim')
    use('Maan2003/lsp_lines.nvim')
    use({
      'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
    })
    use('jose-elias-alvarez/null-ls.nvim')
    use('jose-elias-alvarez/nvim-lsp-ts-utils')
    use('sumneko/lua-language-server')
    use('j-hui/fidget.nvim')
    use('simrat39/rust-tools.nvim')

    -- Autocomplete
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'L3MON4D3/LuaSnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lua',
        'petertriho/cmp-git',
        'ray-x/cmp-treesitter',
        'saadparwaiz1/cmp_luasnip',
      },
    })
    use('rafamadriz/friendly-snippets')

    -- Interactive Swap
    use('mizlan/iswap.nvim')

    -- Bufferline
    use({
      'akinsho/bufferline.nvim',
      tag = '*',
      requires = 'kyazdani42/nvim-web-devicons',
    })

    -- Statusline
    use({
      'famiu/feline.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
    })
    use({
      'SmiteshP/nvim-gps',
      requires = 'nvim-treesitter/nvim-treesitter',
    })

    -- git diffs
    use({
      'sindrets/diffview.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    })

    -- git labels
    use({
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    })

    -- comments
    use('JoosepAlviste/nvim-ts-context-commentstring')
    use('numToStr/Comment.nvim')

    -- debugging
    use({
      'mfussenegger/nvim-dap',
      requires = {
        { 'microsoft/vscode-chrome-debug', run = 'npm install && npm run build' },
        { 'firefox-devtools/vscode-firefox-debug', run = 'npm install && npm run build' },
      },
    })
    use('leoluz/nvim-dap-go')
    use('rcarriga/nvim-dap-ui')
    use('nvim-telescope/telescope-dap.nvim')

    -- Dashboard (start screen)
    use({
      'goolord/alpha-nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
    })

    -- Luapad
    use('rafcamlet/nvim-luapad')

    -- Notifications
    use('rcarriga/nvim-notify')

    -- Tests
    use({
      'nvim-neotest/neotest',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'haydenmeade/neotest-jest',
        'nvim-neotest/neotest-go',
      },
    })

    -- Tpope
    use('tpope/vim-abolish')
    use('tpope/vim-eunuch')
    use('tpope/vim-fugitive')
    use('tpope/vim-surround')
    use('tpope/vim-repeat')
    use('tpope/vim-sleuth')

    -- Miscellaneous
    use('christoomey/vim-tmux-navigator')
    use('tommcdo/vim-fugitive-blame-ext')
  end,
  config = {
    max_jobs = 32,
  },
})
