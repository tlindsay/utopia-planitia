require('blink.cmp').setup({
  keymap = {
    preset = 'enter',
    -- START 6/12/25
    -- Trying to fix tab behavior when snippets are active
    -- It's _almost_ working exactly how I want
    ['<Esc>'] = {
      function(cmp)
        if cmp.snippet_active() then
          require('luasnip').unlink_current()
        end
      end,
      'fallback',
    },
    -- END 6/12/25
    ['<Tab>'] = {
      function(cmp)
        if cmp.snippet_active({ direction = 1 }) then
          return cmp.snippet_forward()
        end
      end,
      'select_next',
      'fallback',
    },
    ['<S-Tab>'] = {
      function(cmp)
        if cmp.snippet_active({ direction = -1 }) then
          return cmp.snippet_backward()
        end
      end,
      'select_prev',
      'fallback',
    },
    ['<C-c>'] = { 'cancel', 'fallback', 'fallback' },
    ['<A-j>'] = { 'scroll_documentation_down', 'fallback' },
    ['<A-k>'] = { 'scroll_documentation_up', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = true,
      },
      list = { selection = { preselect = false, auto_insert = true } },
    },
  },
  completion = {
    keyword = { range = 'full' },
    accept = { auto_brackets = { enabled = false } },
    list = { selection = { preselect = false, auto_insert = true } },
    menu = {
      auto_show = true,

      -- nvim-cmp style menu
      draw = {
        components = {
          -- https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = require('lspkind').symbolic(ctx.kind, {
                  mode = 'symbol',
                })
              end

              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from nvim-web-devicons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          },
        },
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind_icon', 'kind' },
        },
        treesitter = { 'lsp' },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = 'bold' } },
    ghost_text = { enabled = true },
  },
  signature = {
    enabled = true,
  },
  snippets = { preset = 'luasnip' },
  sources = {
    providers = {
      snippets = {
        -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end,
      },
    },
  },
})
