{pkgs, ...}:
with pkgs; [
  # Nix shit
  comma # Comma runs software without installing it. `$ , cowsay neato`
  nh
  nix-index
  nix-output-monitor

  # Custom packages
  replicator.hl
  # replicator.loggo
  replicator.tmux-open-nvim

  # General packages for development and system management
  _1password-cli
  act
  amber # A code search-and-replace tool
  asciinema
  asciinema-agg
  aspell
  aspellDicts.en
  atac
  atuin
  bash-completion
  bat
  bat-extras.batdiff
  bat-extras.batgrep
  bat-extras.batman
  bat-extras.batpipe
  bat-extras.batwatch
  bat-extras.prettybat
  bottom
  coreutils
  doggo
  eza
  fzf
  gettext
  home-manager
  llvmPackages_latest.llvm
  killall
  moreutils
  mosh
  mprocs
  mqttui
  mysql-shell
  navi # zsh cheatsheet auto substitutions!!!
  neofetch
  neovim
  pam-reattach
  pet # Shell snippet mgr
  qmk
  sqlite
  sqruff # SQL formatter/linter
  tailscale
  tailspin # Log tailer
  usql
  wget
  xh # better curl https://github.com/ducaale/xh
  zip

  # Lang specific runtimes
  cue
  go
  lua
  nodePackages.nodejs
  nodePackages.yarn
  python3
  rustc

  # Language Servers and other tools
  air # live reload for go apps
  alejandra
  cargo
  cuelsp
  deadnix
  eslint_d
  golangci-lint
  gomacro # golang repl
  luarocks
  nodePackages_latest.eslint
  nodePackages_latest.typescript-language-server
  prettierd
  python311Packages.pip
  statix
  typescript
  yamllint

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  pinentry-curses
  yubikey-manager

  # Cloud-related tools and SDKs
  (docker.override (args: {buildxSupport = true;}))
  docker-buildx
  docker-credential-helpers
  docker-compose
  fastly
  k9s
  kubectl
  kubernetes-helm
  lazydocker

  # Media-related packages
  ffmpeg
  fd
  harfbuzz
  (nerdfonts.override {fonts = ["FantasqueSansMono" "Iosevka" "Noto"];})

  # Still using asdf for tool versioning
  mise
  asdf-vm

  # Text and terminal utilities
  diff-so-fancy
  difftastic
  direnv
  du-dust
  figlet
  nodePackages_latest.fkill-cli
  fx
  gh
  git
  git-credential-oauth
  git-lfs
  git-town
  glow
  gum
  hub
  hunspell
  iftop
  jq
  jnv
  lazygit
  ncurses
  nushell
  procs
  ripgrep
  starship
  tealdeer
  tree
  tmux
  unrar
  unzip
  yq
  zoxide
]
