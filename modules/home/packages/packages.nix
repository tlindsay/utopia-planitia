{
  pkgs,
  upkgs,
  ...
}:
with pkgs; [
  # Nix shit
  upkgs.nh
  nix-output-monitor

  # Custom packages
  replicator.hl
  replicator.tmux-open-nvim
  replicator.mdns-scanner

  # Use nix-community/fenix for rust toolchains
  (fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])

  # Unstable packages
  upkgs.atuin
  upkgs.fastly
  upkgs.golangci-lint
  upkgs.k9s
  upkgs.moar # Nicer pager
  upkgs.mqttui
  upkgs.neovim
  (upkgs.spotify-player.override {withMediaControl = false;})
  upkgs.tailscale
  (upkgs.tinygo.override {tinygoTests = null;})
  upkgs.wgpu-utils

  # General packages for development and system management
  _1password-cli
  act
  amber # A code search-and-replace tool
  asciinema
  asciinema-agg
  aspell
  aspellDicts.en
  atac
  bash-completion
  bat
  bat-extras.batdiff
  bat-extras.batgrep
  bat-extras.batman
  bat-extras.batpipe
  bat-extras.batwatch
  bottom
  coreutils
  doggo
  eza
  fzf
  gettext
  home-manager
  just
  kdash # Another k8s TUI
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
  python3

  # Language Servers and other tools
  air # live reload for go apps
  alejandra
  cuelsp
  deadnix
  gomacro # golang repl
  luarocks
  statix
  vlang
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
  kubectl
  kubernetes-helm
  lazydocker

  # Media-related packages
  ffmpeg
  fd
  (nerdfonts.override {fonts = ["FantasqueSansMono" "Iosevka" "Noto"];})
  # 👆This will need to change to 👇this when upgrading to 25.05
  # nerd-fonts.fantasque-sans-mono
  # nerd-fonts.iosevka
  # nerd-fonts.noto

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
