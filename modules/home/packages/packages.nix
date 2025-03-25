{
  pkgs,
  upkgs,
  ...
}:
with pkgs; [
  rpi-imager
  # Nix shit
  comma # Comma runs software without installing it. `$ , cowsay neato`
  nh
  nix-index
  nix-output-monitor

  # Custom packages
  replicator.hl
  # replicator.loggo
  replicator.tmux-open-nvim

  # Use nix-community/fenix for rust toolchains
  (fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])

  # Unstable packages
  upkgs.fastly
  upkgs.golangci-lint
  upkgs.mqttui
  upkgs.neovim
  upkgs.tailscale
  (upkgs.tinygo.override {tinygoTests = null;})

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
  just
  llvmPackages_latest.llvm
  killall
  moreutils
  mosh
  mprocs
  mysql-shell
  navi # zsh cheatsheet auto substitutions!!!
  neofetch
  pam-reattach
  pet # Shell snippet mgr
  qmk
  sqlite
  sqruff # SQL formatter/linter
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

  # Language Servers and other tools
  air # live reload for go apps
  alejandra
  cuelsp
  deadnix
  eslint_d
  gomacro # golang repl
  luarocks
  nodePackages_latest.eslint
  nodePackages_latest.typescript-language-server
  prettierd
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
  k9s
  kubectl
  kubernetes-helm
  lazydocker

  # Media-related packages
  ffmpeg
  fd
  (nerdfonts.override {fonts = ["FantasqueSansMono" "Iosevka" "Noto"];})

  # Still using asdf for tool versioning
  asdf-vm

  # Text and terminal utilities
  diff-so-fancy
  difftastic
  direnv
  du-dust
  figlet
  fx
  gh
  git
  git-credential-oauth
  git-lfs
  git-town
  glow
  gum
  hub
  iftop
  jq
  jnv
  lazygit
  ncurses
  nushell
  procs
  ripgrep
  spotify-player
  starship
  tealdeer
  timg # tmux img viewer
  tree
  tmux
  unrar
  unzip
  yq
  zoxide
]
