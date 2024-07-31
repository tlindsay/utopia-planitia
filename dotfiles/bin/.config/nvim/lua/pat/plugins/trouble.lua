local trouble = require('trouble')
trouble.setup({
  focus = true,
  auto_preview = false,
  follow = false,
  keys = {
    ['<c-s>'] = function()
      trouble.jump_split()
      trouble.close()
    end,
    ['<c-v>'] = function()
      trouble.jump_vsplit()
      trouble.close()
    end,
    ['<c-t>'] = function(_, ctx)
      local bufnr = ctx.item.buf
      if not vim.fn.buflisted(bufnr) then
        vim.api.nvim_set_option_value('buflisted', true, { buf = bufnr })
      end

      vim.cmd(string.format('tab sb %d', bufnr))
      trouble.close()
    end,
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
          trouble.fold_close_all()
          trouble.fold_reduce()
          trouble.fold_reduce()
        end,
      },
      keys = {
        ['<space>'] = 'fold_toggle',
        ['<s-space>'] = 'fold_toggle_recursive',
      },
    },

    inspect = {
      mode = 'lsp',
      params = {
        include_current = true,
        include_declaration = true,
      },
      auto_preview = false,
      preview = {
        type = 'float',
        border = 'rounded',
      },
      keys = {
        ['<cr>'] = 'jump_close',
        ['<esc>'] = 'close',
        ['<space>'] = 'preview',
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
})
