local wk = require('which-key')
local ufo = require('ufo')
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
wk.register({
  z = {
    R = { ufo.openAllFolds, 'Open all folds' },
    M = { ufo.closeAllFolds, 'Close all folds' },
  },
  [''] = { 'za', 'Toggle current fold' },
})
ufo.setup({
  provider_selector = function()
    return {
      'treesitter', --[[ 'indent'  ]]
    }
  end,
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local endText = vim.api.nvim_buf_get_text(0, endLnum - 1, 0, endLnum - 1, -1, {})[1]
    local fmtText = string.gsub(endText, '^%s+', '')
    local newVirtText = {}
    local suffix = (' ... %s | ▼ %d lines'):format(fmtText, endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
  end,
})
