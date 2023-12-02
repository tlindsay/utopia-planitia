return {
  'nvim-lua/plenary.nvim',
  'smartpde/debuglog', -- Logging plugin for debugging lua configs
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  -- Project Management
  {
    'Dax89/IDE.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'rcarriga/nvim-notify',
      'stevearc/dressing.nvim',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
  },

  -- Pane Management
  {
    'mrjones2014/smart-splits.nvim',
    -- dir = '~/Code/make/smart-splits/',
  },

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
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
  {
    'nvim-neorg/neorg',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neorg/neorg-telescope',
    },
  },

  -- Symbol Outline
  'hedyhli/outline.nvim',

  -- Indentation Guides
  -- 'lukas-reineke/indent-blankline.nvim',
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
  'haringsrob/nvim_context_vt',
  -- { 'HiPhish/nvim-ts-rainbow2', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  'HiPhish/rainbow-delimiters.nvim',
  { 'Wansmer/treesj',            dependencies = { 'nvim-treesitter/nvim-treesitter' } },

  -- More textobjects
  'chrisgrieser/nvim-various-textobjs',

  -- Color schemes
  {
    'folke/tokyonight.nvim',
    -- dir = '~/Code/make/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },
  'nvchad/nvim-colorizer.lua',

  -- LSP
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'onsails/lspkind-nvim',
  -- 'Maan2003/lsp_lines.nvim',
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'folke/neodev.nvim',
  -- '~/code/make/lsp_lines.nvim'
  {
    'folke/trouble.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
  },
  -- 'jose-elias-alvarez/null-ls.nvim',
  {
    'mangelozzi/nvim-rgflow.lua',
    cond = function()
      return vim.fn.executable('rg') and 1
    end,
  },
  {
    'creativenull/efmls-configs-nvim',
    version = 'v1.x.x',
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  'elentok/format-on-save.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'jose-elias-alvarez/typescript.nvim',
  { 'LuaLS/lua-language-server', submodules = false },
  { 'j-hui/fidget.nvim',         tag = 'legacy' },
  'simrat39/rust-tools.nvim',
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    'ray-x/navigator.lua',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
    },
  },

  -- Syntax Definitions
  'fladson/vim-kitty',

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
    version = '*',
    dependencies = 'kyazdani42/nvim-web-devicons',
  },

  -- Statusline
  {
    'freddiehaddad/feline.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
  },
  -- {
  --   'SmiteshP/nvim-gps',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  -- },
  {
    'SmiteshP/nvim-navic',
    dependencies = 'neovim/nvim-lspconfig',
  },

  -- Scroll Bar
  'petertriho/nvim-scrollbar',

  -- git diffs
  {
    'sindrets/diffview.nvim',
    commit = '6420a73b340fdb1f842479cd7640dcca9ec6f5d1',
    dependencies = { 'nvim-lua/plenary.nvim' },
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
  'rcarriga/nvim-dap-ui',
  'nvim-telescope/telescope-dap.nvim',

  -- Dashboard start screen
  {
    'goolord/alpha-nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    lazy = true,
  },

  -- Luapad
  'rafcamlet/nvim-luapad',

  -- Notifications
  'rcarriga/nvim-notify',

  -- Tests
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'haydenmeade/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-go',
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
  -- 'tommcdo/vim-fugitive-blame-ext',
  { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
  {
    -- '9seconds/repolink.nvim',
    'tlindsay/repolink.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'RepoLink' },
  },

  'chrisbra/unicode.vim',
}
