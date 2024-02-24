{pkgs}:
with pkgs; [
  # General packages for development and system management
  _1password
  act
  aspell
  aspellDicts.en
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
  eza
  fzf
  home-manager
  llvmPackages_latest.llvm
  killall
  mosh
  mprocs
  neofetch
  neovim
  qmk
  sqlite
  usql
  wget
  xh # better curl https://github.com/ducaale/xh
  zip

  # Lang specific runtimes
  go
  tinygo
  lua
  nodePackages.nodejs
  nodePackages.yarn
  python3
  rustc

  # Language Servers and other tools
  luarocks
  cargo
  python311Packages.pip
  nixd
  nixfmt
  statix
  alejandra

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  pinentry
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
  harfbuzz
  (nerdfonts.override {fonts = ["FantasqueSansMono"];})

  # Still using asdf for tool versioning
  asdf-vm

  # Text and terminal utilities
  diff-so-fancy
  direnv
  du-dust
  figlet
  fx
  gh
  git
  glow
  gum
  hub
  hunspell
  iftop
  jq
  lazygit
  kitty
  ncurses
  nix-index
  nix-output-monitor
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
