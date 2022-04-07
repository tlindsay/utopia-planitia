--[[
Neovim init file
Version: 0.50.1 - 2022/03/15
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua
--]]

-- Import Lua modules
require('pat.core/settings')
require('pat.core/autocmds')
require('pat.core/keymaps')
require('pat.core/colors')
require('pat.packer_init')
require('pat.plugins/nvim-tree')
require('pat.plugins/indent-blankline')
require('pat.plugins/nvim-gps')
require('pat.plugins/bufferline')
require('pat.plugins/feline')
require('pat.plugins/vista')
require('pat.plugins/nvim-cmp')
require('pat.plugins/nvim-autopairs')
require('pat.plugins/null-ls')
require('pat.plugins/nvim-lspconfig')
require('pat.plugins/nvim-notify')
require('pat.plugins/nvim-treesitter')
require('pat.plugins/telescope')
require('pat.plugins/vim-ultest')
require('pat.plugins/alpha-nvim')

require('pat.utils')
