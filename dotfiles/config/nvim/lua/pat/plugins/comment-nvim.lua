require('Comment').setup({
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  -- pre_hook = function(ctx)
  --   -- return require('Comment.jsx').calculate(ctx)
  --   -- Only calculate commentstring for tsx filetypes
  --   if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'glimmer' or vim.bo.filetype == 'handlebars' then
  --     local U = require('Comment.utils')
  --
  --     -- Determine whether to use linewise or blockwise commentstring
  --     local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'
  --
  --     -- Determine the location where to calculate commentstring from
  --     local location = nil
  --     if ctx.ctype == U.ctype.block then
  --       location = require('ts_context_commentstring.utils').get_cursor_location()
  --     elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
  --       location = require('ts_context_commentstring.utils').get_visual_start_location()
  --     end
  --
  --     return require('ts_context_commentstring.internal').calculate_commentstring({
  --       key = type,
  --       location = location,
  --     })
  --   end
  -- end,
})
