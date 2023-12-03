{ pkgs }:

with pkgs; [
  # General packages for development and system management
	_1password
  act
  antibody
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
  gcc12
  killall
  neofetch
  neovim
  openssh
  sqlite
  wget
  zip

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
  lazydocker

  # Media-related packages
  ffmpeg
  fd
  harfbuzz
	(nerdfonts.override { fonts = ["FantasqueSansMono"]; })

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
  lua
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
