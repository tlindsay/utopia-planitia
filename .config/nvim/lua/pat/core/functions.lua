local M = {}

-- function M.getHlGroup()
--   -- vim.cmd([[
--   --   " for i1 in synstack(line('.'), col('.'))
--   --   "   let i2 = synIDTrans(i1)
--   --   "   let n1 = synIDattr(i1, 'name')
--   --   "   let n2 = synIDattr(i2, 'name')
--   --   "   echo n1 '->' n2
--   --   " endfor
--   local call = vim.api.nvim_call_function
--
--   local line = call('line', { '.' })
--   local col = call('col', { '.' })
--   local syntaxBlob = call('synID', { line, col, 1 })
--   local trans = call('synIDtrans', { syntaxBlob })
--   P(call('synIDattr', { syntaxBlob, 'name' }) .. '->' .. call('synIDattr', { trans, 'name' }))
--   --   " let l:syntaxBlob = synID(line('.'), col('.'), 1)
--   --   " echo synIDattr(l:syntaxBlob, 'name') . ' -> ' . synIDattr(synIDtrans(l:syntaxBlob), 'name')
--   -- ]])
-- end

vim.cmd([[
  function! ShowCurrentHighlight()
    echom "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
  endfunction
]])

vim.cmd([[
  function! SayHi()
    echo "hello there!"
  endfunction
]])

function M.getHlGroup()
  vim.api.nvim_call_function('ShowCurrentHighlight', {})
end

return M
