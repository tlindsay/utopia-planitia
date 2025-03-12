require('blink.cmp').setup({
  keymap = {
    preset = 'enter',
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
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  completion = {
    keyword = { range = 'full' },
    accept = { auto_brackets = { enabled = false } },
    list = { selection = { preselect = false, auto_insert = true } },
    menu = {
      auto_show = true,
      border = 'rounded',

      -- nvim-cmp style menu
      draw = {
        columns = {
          { 'label',     'label_description', gap = 1 },
          { 'kind_icon', 'kind' },
        },
        treesitter = { 'lsp' },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = 'padded' } },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true, window = { border = 'padded' } },
  snippets = { preset = 'luasnip' },
})
