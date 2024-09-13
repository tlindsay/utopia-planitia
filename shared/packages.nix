{
  pkgs,
  upkgs,
}:
with pkgs; [
  # Nix shit
  comma # Comma runs software without installing it. `$ , cowsay neato`
  nh
  nix-index
  nix-output-monitor

  # General packages for development and system management
  _1password
  act
  amber # A code search-and-replace tool
  aspell
  aspellDicts.en
  atac
  upkgs.atuin
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
  home-manager
  llvmPackages_latest.llvm
  killall
  moreutils
  mosh
  mprocs
  mysql-shell
  navi # zsh cheatsheet auto substitutions!!!
  neofetch
  upkgs.neovim
  pet # Shell snippet mgr
  qmk
  sqlite
  upkgs.tailscale
  usql
  wget
  xh # better curl https://github.com/ducaale/xh
  zip

  # Lang specific runtimes
  go
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
  air # live reload for go apps
  gomacro # golang repl
  ## TS/JS:
  nodePackages_latest.typescript-language-server
  nodePackages_latest.eslint
  typescript
  eslint_d
  prettierd

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
  (nerdfonts.override {fonts = ["FantasqueSansMono"];})

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
  glow
  gum
  hub
  hunspell
  iftop
  jq
  jnv
  lazygit
  kitty
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
