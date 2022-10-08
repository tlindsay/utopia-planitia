--[[
Neovim init file
Version: 0.50.1 - 2022/03/15
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua
--]]

-- Import Lua modules

require('pat.utils')

R('pat.core/settings')
R('pat.core/autocmds')
R('pat.core/colors')
R('pat.core/keymaps')
R('pat.packer_init')
R('pat.plugins/ide')
R('pat.plugins/indent-blankline')
R('pat.plugins/nvim-gps')
R('pat.plugins/bufferline')
R('pat.plugins/comment-nvim')
R('pat.plugins/nvim-dap')
R('pat.plugins/neotree')
--[[ -- R('pat.plugins/diffview') ]]
R('pat.plugins/feline')
R('pat.plugins/gitsigns')
R('pat.plugins/iswap')
R('pat.plugins/luasnip')
R('pat.plugins/nvim-cmp')
R('pat.plugins/nvim-autopairs')
R('pat.plugins/null-ls')
R('pat.plugins/nvim-lspconfig')
R('pat.plugins/nvim-luapad')
R('pat.plugins/nvim-notify')
R('pat.plugins/nvim-treesitter')
R('pat.plugins/nvim-ufo')
-- R('pat.plugins/pretty-fold')
R('pat.plugins/telescope')
R('pat.plugins/neotest')
R('pat.plugins/alpha-nvim')
-- R('pat.plugins/dashboard')
R('pat.plugins/colorizer')
