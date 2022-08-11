-----------------------------------------------------------
-- Autocomplete configuration file
-----------------------------------------------------------

-- Plugin: nvim-cmp
-- url: https://github.com/hrsh7th/nvim-cmp

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local kind_icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = 'ﴯ',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

cmp.setup({
  -- Load snippet support
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Completion settings
  completion = {
    --completeopt = 'menu,menuone,noselect'
    keyword_length = 2,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- Key mapping
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      -- behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),

    -- Tab mapping
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  }),

  -- Load sources, see: https://github.com/topics/nvim-cmp
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' }, -- Causing problems in ember files 05/27
    { name = 'treesitter' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer' },
  },

  -- Formatting
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      menu = {
        buffer = ' ﬘',
        nvim_lsp = ' ',
        nvim_lsp_signature_help = ' ',
        luasnip = ' 🐍',
        treesitter = ' ',
        nvim_lua = ' ',
        spell = ' 暈',
      },
    }),
    -- format = function(entry, vim_item)
    --   -- print(vim.inspect(vim_item.kind))
    --   vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
    --   vim_item.menu = ({
    --     buffer = ' ﬘',
    --     nvim_lsp = ' ',
    --     luasnip = ' 🐍',
    --     treesitter = ' ',
    --     nvim_lua = ' ',
    --     spell = ' 暈',
    --   })[entry.source.name]
    --   return vim_item
    -- end,

    before = function(entry, vim_item)
      P(entry)
      P(vim_item)
      return vim_item
    end,
  },

  -- Here there be dragons
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
})

-- Use git source for git commits
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  }),
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
    -- { name = 'buffer', option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
  },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  completion = { autocomplete = true },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
