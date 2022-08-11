vim.opt.foldcolumn = 'auto:4'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
require('ufo').setup({
  provider_selector = function()
    return {
      'treesitter', --[[ 'indent'  ]]
    }
  end,
})
