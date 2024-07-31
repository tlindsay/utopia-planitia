--[[
Neovim init file
Version: 0.50.1 - 2022/03/15
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua
--]]

vim.g.mapleader = ','

require('pat.core/settings')

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
  dev = { path = '~/Code/make' },
  -- defaults = { lazy = true },
  profiling = {
    loader = true,
    require = true,
  },
})

--------------------------------
-- START PERF PROFILING CONFIG
--------------------------------
local should_profile = os.getenv('NVIM_PROFILE')
if should_profile then
  require('profile').instrument_autocmds()
  if should_profile:lower():match('^start') then
    require('profile').start('*')
  else
    require('profile').instrument('*')
  end
end
local function toggle_profile()
  local prof = require('profile')
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = 'Save profile to:', completion = 'file', default = 'profile.json' }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format('Wrote %s', filename))
      end
    end)
  else
    prof.start('*')
  end
end
vim.keymap.set('', '<leader><leader>P', toggle_profile)
--------------------------------
-- END PERF PROFILING CONFIG
--------------------------------

-- Import Lua modules
require('pat.utils')

require('pat.core/autocmds')
require('pat.core/colors')
require('pat.core/keymaps')

-- Configure plugins
require('pat.plugins/devicons') -- Load first for overrides
require('pat.plugins/alpha-nvim')
require('pat.plugins/bufferline')
require('pat.plugins/colorizer')
require('pat.plugins/comment-nvim')
require('pat.plugins/devdocs')
require('pat.plugins/diffview')
require('pat.plugins/dressing')
require('pat.plugins/feline')
require('pat.plugins/gitsigns')
require('pat.plugins/global-note')
require('pat.plugins/goplay')
require('pat.plugins/hlchunk')
require('pat.plugins/iswap')
require('pat.plugins/neotest')
require('pat.plugins/neotree')
require('pat.plugins/nvim-lspconfig')
require('pat.plugins/luasnip') -- Needs to be after lspconfig, since that's where go.nvim is bootstrapped
require('pat.plugins/none-ls')
require('pat.plugins/nvim-autopairs')
require('pat.plugins/nvim-cmp')
require('pat.plugins/nvim-dap')
require('pat.plugins/nvim-navic')
require('pat.plugins/nvim-luapad')
require('pat.plugins/nvim-notify')
require('pat.plugins/nvim-scrollbar')
require('pat.plugins/nvim-treesitter')
require('pat.plugins/nvim-ufo')
require('pat.plugins/repolink')
require('pat.plugins/rgflow')
require('pat.plugins/smart-splits')
require('pat.plugins/telescope')
require('pat.plugins/textobjs')
require('pat.plugins/trouble')

require('pat.plugins/go-gently')
