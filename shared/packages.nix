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
  neofetch
  neovim
  openssh
  sqlite
  wget
  zip

  # Lang specific runtimes
  go
  tinygo
  lua
  nodePackages.nodejs
  python3
  rustc

  # Language Servers and other tools
  luarocks
  cargo
  python311Packages.pip
  nixd
  alejandra

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  pinentry
  yubikey-manager

  # Cloud-related tools and SDKs
  #
  # docker marked broken as of Nov 15, 2023
  # https://github.com/NixOS/nixpkgs/issues/267685
  #
  # docker
  # docker-compose
  #
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
  figlet
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
