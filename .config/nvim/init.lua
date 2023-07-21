--[[
Neovim init file
Version: 0.50.1 - 2022/03/15
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua
--]]

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
local plugins = require('pat.plugins')
require('lazy').setup(plugins, {
  ui = { border = 'rounded' },
})

-- Import Lua modules
require('pat.utils')

require('pat.core/settings')
require('pat.core/autocmds')
require('pat.core/colors')
require('pat.core/keymaps')

-- Configure plugins
R('pat.plugins/alpha-nvim')
R('pat.plugins/bufferline')
R('pat.plugins/colorizer')
R('pat.plugins/comment-nvim')
-- R('pat.plugins/diffview')
R('pat.plugins/feline')
-- R('pat.plugins/lualine')
R('pat.plugins/gitsigns')
-- R('pat.plugins/ide')
R('pat.plugins/indent-blankline')
R('pat.plugins/iswap')
R('pat.plugins/luasnip')
R('pat.plugins/neorg')
R('pat.plugins/neotest')
R('pat.plugins/neotree')
R('pat.plugins/null-ls')
R('pat.plugins/nvim-autopairs')
R('pat.plugins/nvim-cmp')
R('pat.plugins/nvim-dap')
-- R('pat.plugins/nvim-gps')
R('pat.plugins/nvim-navic')
R('pat.plugins/nvim-lspconfig')
R('pat.plugins/nvim-luapad')
R('pat.plugins/nvim-notify')
R('pat.plugins/nvim-scrollbar')
R('pat.plugins/nvim-treesitter')
R('pat.plugins/nvim-ufo')
R('pat.plugins/symbols-outline')
R('pat.plugins/smart-splits')
R('pat.plugins/telescope')
R('pat.plugins/textobjs')
-- R('pat.plugins/noice')
