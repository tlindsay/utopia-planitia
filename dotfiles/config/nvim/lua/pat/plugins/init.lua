return {
  'nvim-lua/plenary.nvim',
  'smartpde/debuglog', -- Logging plugin for debugging lua configs
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  -- },
  'stevearc/dressing.nvim',

  -- Pane Management
  'mrjones2014/smart-splits.nvim',

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
  },
  'nvim-telescope/telescope-file-browser.nvim',
  -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'arch -arm64 make' },
  'nvim-telescope/telescope-github.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'LinArcX/telescope-command-palette.nvim',
  'gbrlsnchs/telescope-lsp-handlers.nvim',
  'xiyaowong/telescope-emoji.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Indentation Guides
  'shellRaining/hlchunk.nvim',

  -- Which Key
  'folke/which-key.nvim',

  -- Autopair
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',

  -- Token Highlight
  'tzachar/local-highlight.nvim',

  -- Pretty Fold
  'anuvyklack/pretty-fold.nvim',
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
  },

  -- Icons
  'nvim-tree/nvim-web-devicons',

  -- Treesitter interface
  { 'nvim-treesitter/nvim-treesitter',          build = ':TSUpdate',       lazy = false },
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/nvim-treesitter-context',
  'RRethy/nvim-treesitter-endwise',
  'andersevenrud/nvim_context_vt',
  'HiPhish/rainbow-delimiters.nvim',
  { 'Wansmer/treesj',       lazy = true, dependencies = { 'nvim-treesitter/nvim-treesitter' } },

  -- More textobjects
  'chrisgrieser/nvim-various-textobjs',

  -- Color schemes
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },
  'nvchad/nvim-colorizer.lua',

  -- LSP
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'onsails/lspkind-nvim',
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  { 'RaafatTurki/corn.nvim' },
  'icholy/lsplinks.nvim',
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        'lazy.nvim',
        'nvim-culprit',
      },
    },
  },
  'folke/neoconf.nvim',
  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'mangelozzi/nvim-rgflow.lua',
    cond = function()
      return vim.fn.executable('rg') and 1
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvimtools/none-ls-extras.nvim',
    },
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
  },
  'elentok/format-on-save.nvim',
  { 'LuaLS/lua-language-server', submodules = false },
  {
    'j-hui/fidget.nvim',
  },
  'simrat39/rust-tools.nvim',
  'simrat39/inlay-hints.nvim',
  { 'tlindsay/go-gently.nvim',   dev = true },

  -- Syntax Definitions
  'direnv/direnv.vim',

  -- Autocomplete
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'petertriho/cmp-git',
      'ray-x/cmp-treesitter',
      'saadparwaiz1/cmp_luasnip',
      'tzachar/cmp-ai',
      'snikimonkd/cmp-go-pkgs',
    },
  },
  'rafamadriz/friendly-snippets',

  -- Docs Browser
  {
    'luckasRanarison/nvim-devdocs',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- Interactive Swap
  'mizlan/iswap.nvim',

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    branch = 'main',
    -- version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },

  -- Statusline
  {
    'freddiehaddad/feline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'SmiteshP/nvim-navic',
    dependencies = 'neovim/nvim-lspconfig',
  },

  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
      'neovim/nvim-lspconfig',
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
      'numToStr/Comment.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },

  -- Scroll Bar
  'petertriho/nvim-scrollbar',

  -- git diffs
  {
    'sindrets/diffview.nvim',
    commit = '6420a73b340fdb1f842479cd7640dcca9ec6f5d1',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'yutkat/git-rebase-auto-diff.nvim',
    ft = { 'gitrebase' },
    config = function()
      require('git-rebase-auto-diff').setup()
    end,
  },

  -- git labels
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- comments
  'JoosepAlviste/nvim-ts-context-commentstring',
  'numToStr/Comment.nvim',

  -- debugging
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'microsoft/vscode-chrome-debug',         run = 'npm install && npm run build' },
      { 'firefox-devtools/vscode-firefox-debug', run = 'npm install && npm run build' },
    },
  },
  'leoluz/nvim-dap-go',
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
  },
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',

  -- Dashboard start screen
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
  },

  -- Playgrounds
  'rafcamlet/nvim-luapad',

  -- Notifications
  'rcarriga/nvim-notify',

  -- Tests
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'haydenmeade/neotest-jest',
      'marilari88/neotest-vitest',
      -- 'nvim-neotest/neotest-go',
      'fredrikaverpil/neotest-golang',
    },
  },

  -- Tpope
  'tpope/vim-abolish',
  'tpope/vim-eunuch',
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-sleuth',

  -- Miscellaneous,
  'christoomey/vim-tmux-navigator',
  { 'ellisonleao/glow.nvim', config = true,                      cmd = 'Glow' },
  { 'glacambre/firenvim',    build = ':call firenvim#install(0)' },
  {
    '9seconds/repolink.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'RepoLink' },
  },
  {
    'https://git.sr.ht/~thatdarnpat/nvim-culprit',
    config = function()
      require('culprit').setup({ popupConfig = { anchor = 'NW' } })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
  },
  'backdround/global-note.nvim',
  {
    'cenk1cenk2/jq.nvim',
    dependencies = {
      -- https://github.com/nvim-lua/plenary.nvim
      'nvim-lua/plenary.nvim',
      -- https://github.com/MunifTanjim/nui.nvim
      'MunifTanjim/nui.nvim',
      -- https://github.com/grapp-dev/nui-components.nvim
      'grapp-dev/nui-components.nvim',
    },
  },
  {
    'camspiers/luarocks',
    lazy = true,
    dependencies = { 'rcarriga/nvim-notify' },
    opts = {
      rocks = {
        'penlight',
      },
    },
  },

  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- Optional
      {
        'stevearc/dressing.nvim',      -- Optional: Improves the default Neovim UI
        opts = {},
      },
    },
    -- config = true
  },

  { 'stevearc/profile.nvim', lazy = true },
}
