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
  upkgs.awscli2
  upkgs.claude-code
  upkgs.container
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
  curl
  doggo
  eza
  fzf
  gettext
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
  skate # System KV Store
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
  (let
    python = let
      packageOverrides = _self: super: {
        tenacity = super.tenacity.overridePythonAttrs (_old: rec {
          pname = "tenacity";
          version = "8.5.0";
          src = fetchPypi {
            inherit pname version;
            hash = null;
          };
        });
        google-cloud-aiplatform = super.buildPythonPackage {
          pname = "google-cloud-aiplatform";
          version = "1.99.0";

          src = super.pkgs.fetchFromGitHub {
            owner = "googleapis";
            repo = "python-aiplatform";
            rev = "v1.99.0";
            hash = null;
          };

          propagatedBuildInputs = with super; [
            docstring-parser
            google-api-core
            google-auth
            google-cloud-bigquery
            google-cloud-resource-manager
            google-cloud-storage
            packaging
            proto-plus
            protobuf
            pydantic
            shapely
            typing-extensions
          ];
        };
      };
    in
      python312.override {
        inherit packageOverrides;
        self = python;
      };
  in
    python.withPackages (ps: [
      (ps.aider-chat.withOptional {
        withBedrock = true;
        withBrowser = true;
      })
      ps.google-cloud-aiplatform
      ps.tenacity
    ]))

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
  # (nerdfonts.override {fonts = ["FantasqueSansMono" "Iosevka" "Noto"];})
  # 👆This will need to change to 👇this when upgrading to 25.05
  nerd-fonts.fantasque-sans-mono
  nerd-fonts.iosevka
  nerd-fonts.noto

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
