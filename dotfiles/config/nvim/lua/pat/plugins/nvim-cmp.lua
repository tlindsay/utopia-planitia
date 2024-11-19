-----------------------------------------------------------
-- Autocomplete configuration file
-----------------------------------------------------------

local log = require('pat.core/log')

-- Plugin: nvim-cmp
-- url: https://github.com/hrsh7th/nvim-cmp

local cmp = require('cmp')
local compare = require('cmp.config.compare')
local types = require('cmp.types')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local kind_icons = {
  Text = '',
  Method = '󰆧',
  Function = '󰊕',
  Constructor = '',
  Field = '󰇽',
  Variable = '󰂡',
  Class = '󰠱',
  Interface = '',
  Module = '',
  Property = '󰜢',
  Unit = '',
  Value = '󰎠',
  Enum = '',
  Keyword = '󰌋',
  Snippet = '',
  Color = '󰏘',
  File = '󰈙',
  Reference = '',
  Folder = '󰉋',
  EnumMember = '',
  Constant = '󰏿',
  Struct = '',
  Event = '',
  Operator = '󰆕',
  TypeParameter = '󰅲',
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
    completeopt = 'menu,menuone,noselect,preview',
    keyword_length = 2,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- Source ranking
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },

  -- Key mapping
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- ['<CR>'] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Insert,
    --   select = true,
    -- }),
    ['<CR>'] = function(fallback)
      if not cmp.visible() then
        fallback()
      elseif cmp.get_selected_entry() ~= nil and cmp.get_selected_entry().source.name == 'nvim_lsp_signature_help' then
        -- Don't block <CR> if signature help is active
        -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
        fallback()
      else
        cmp.confirm({
          -- Replace word if completing in the middle of a word
          -- https://github.com/hrsh7th/nvim-cmp/issues/664
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        })
      end
    end,

    -- Tab mapping
    -- ['<Tab>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end,
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
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
    { name = 'lazydev' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'go_pkgs' },
    { name = 'treesitter' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer' },
  },

  -- Formatting
  -- formatting = {
  --   format = lspkind.cmp_format({
  --     mode = 'symbol_text',
  --     menu = {
  --       buffer = '󰽘 ',
  --       nvim_lsp = ' ',
  --       nvim_lsp_signature_help = ' ',
  --       luasnip = ' ',
  --       treesitter = '󰐅 ',
  --       nvim_lua = ' ',
  --       spell = '󰓆 ',
  --     },
  --   }),
  -- },

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
  formatting = {
    expandable_indicator = true,
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      local kind = require('lspkind').cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
        menu = {
          buffer = '󰽘 Buf',
          nvim_lsp = ' LSP',
          nvim_lsp_signature_help = ' LSP',
          luasnip = ' Snip',
          treesitter = '󰐅 TS',
          nvim_lua = ' Lua',
          lazydev = ' Lua',
          spell = '󰓆 Spell',
        },
      })(entry, vim_item)
      -- log.debug('cmp formatting: ', { lspkind = kind, vim_item_kind = vim_item.kind })
      -- local strings = vim.split(kind.kind, '%s', { trimempty = true })
      -- kind.kind = ' ' .. (strings[1] or '') .. ' '
      -- kind.menu = '    (' .. (strings[2] or '') .. ')'

      return kind
    end,
  },

  -- Here there be dragons
  experimental = {
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
  completion = { autocomplete = { types.cmp.TriggerEvent.TextChanged } },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
