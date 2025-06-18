---@diagnostic disable: missing-fields
local trouble = require('trouble')

local function jump_tab(self, ctx)
  local item = ctx.item
  local bufnr = item.buf
  local Preview = require('trouble.view.preview')
  local Util = require('trouble.util')

  vim.schedule(function()
    Preview.close()
  end)
  if not item then
    return Util.warn('No item to jump to')
  end

  if not (item.buf or item.filename) then
    Util.warn('No buffer or filename for item')
    return
  end

  item.buf = item.buf or vim.fn.bufadd(item.filename)

  if not vim.api.nvim_buf_is_loaded(item.buf) then
    vim.fn.bufload(item.buf)
  end
  if not vim.bo[item.buf].buflisted then
    vim.bo[item.buf].buflisted = true
  end
  local main = self:main()
  local win = main and main.win or 0

  vim.api.nvim_win_call(win, function()
    -- save position in jump list
    vim.cmd("normal! m'")
  end)

  vim.api.nvim_win_call(win, function()
    vim.cmd('tabe')
    win = vim.api.nvim_get_current_win()
  end)

  vim.api.nvim_win_set_buf(win, item.buf)
  -- order of the below seems important with splitkeep=screen
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_win_set_cursor(win, item.pos)
  vim.api.nvim_win_call(win, function()
    vim.cmd('norm! zzzv')
  end)
  return item
end

trouble.setup({
  focus = true,
  auto_preview = false,
  follow = false,
  keys = {
    ['<C-x>'] = 'jump_split_close',
    ['<C-v>'] = 'jump_vsplit_close',
    ['<C-t>'] = jump_tab,
  },
  modes = {
    lsp_references = {
      params = {
        include_current = true,
        include_declaration = true,
      },
    },

    symbols = {
      pinned = true,
      focus = false,
      win = {
        position = 'right',
        size = { width = 45 },
        on_mount = function(self)
          trouble.fold_close_all(self, {})
          trouble.fold_reduce(self, {})
          trouble.fold_reduce(self, {})
        end,
      },
      keys = {
        ['<Space>'] = 'fold_toggle',
        ['<S-space>'] = 'fold_toggle_recursive',
      },
    },

    inspect = {
      mode = 'lsp',
      params = {
        include_current = true,
        include_declaration = true,
      },
      auto_preview = true,
      preview = {
        type = 'float',
        border = 'rounded',
      },
      keys = {
        ['<CR>'] = 'jump_close',
        ['<ESC>'] = 'close',
        ['<Space>'] = 'preview',
      },
    },

    cascade = {
      mode = 'diagnostics', -- inherit from diagnostics mode
      filter = function(items)
        local severity = vim.diagnostic.severity.HINT
        for _, item in ipairs(items) do
          severity = math.min(severity, item.severity)
        end
        return vim.tbl_filter(function(item)
          return item.severity == severity
        end, items)
      end,
    },
  },
  picker = {
    actions = require('trouble.sources.snacks').actions,
    win = {
      input = {
        keys = {
          ['<c-q>'] = {
            'trouble_open',
            mode = { 'n', 'i' },
          },
        },
      },
    },
  },
})
