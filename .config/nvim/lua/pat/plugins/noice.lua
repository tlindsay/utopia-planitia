local config = {
  cmdline = {
    enabled = true, -- enables the Noice cmdline UI
    view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = {}, -- extra opts for the cmdline view. See section on views
    ---@type table<string, CmdlineFormat>
    format = {
      -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
      -- view: (default is cmdline view)
      -- opts: any options passed to the view
      -- icon_hl_group: optional hl_group for the icon
      cmdline = { pattern = '^:', icon = '', lang = 'vim' },
      search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
      search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
      filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
      lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
      help = { pattern = '^:%s*h%s+', icon = '' },
      -- lua = false, -- to disable a format, set to `false`
    },
  },
  messages = {
    view_history = 'messages',
  },
  lsp = {
    progress = { enabled = false },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  routes = {
    view = 'notify',
    filter = { event = 'msg_showmode' },
  },
  views = {
    cmdline_popup = {
      position = {
        row = 5,
        col = '50%',
      },
      size = {
        min_width = 60,
        width = 'auto',
        height = 'auto',
      },
    },
    popupmenu = {
      relative = 'editor',
      position = {
        row = 8,
        col = '50%',
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = 'rounded',
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = {
          Normal = 'Normal',
          FloatBorder = 'DiagnosticInfo',
        },
      },
    },
  },
}

require('noice').setup(config)
