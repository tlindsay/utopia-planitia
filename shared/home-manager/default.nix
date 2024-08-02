{
  config,
  pkgs,
  upkgs,
  lib,
  user,
  ...
}: let
  name = "Patrick Lindsay";
  email = "pat@thatdarnpat.com";
in {
  imports = [
    ./zsh
    ./kitty.nix
    #   # ./git
    #   # ./ssh
    #   # ./nvim
    ./tmux
  ];
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    package = upkgs.atuin;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.ds1.federation";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight_moon";
    };
    syntaxes = {
      jq = {
        src = pkgs.fetchFromGitHub {
          owner = "zogwarg";
          repo = "SublimeJQ";
          rev = "master";
          hash = null;
        };
        file = "JQ.sublime-syntax";
      };
    };
    themes = let
      tokyo = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "tokyonight.nvim";
        rev = "main";
        hash = null;
      };
    in {
      tokyonight_moon = {
        src = tokyo;
        file = "extras/sublime/tokyonight_moon.tmTheme";
      };
    };
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.navi;
  };

  programs.nushell = {
    enable = true;
  };

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        liveViewAutoRefresh = true;
      };
    };
  };

  programs.pet = {
    enable = true;
    selectcmdPackage = pkgs.fzf;
    settings = {};
    snippets = [];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
      whitelist = {
        prefix = ["~/Code/"];
      };
    };
  };

  programs.nix-index = {
    enable = true;
  };
  programs.command-not-found.enable = false;

  # git = {
  #   enable = false;
  #   ignores = [ "*.swp" ];
  #   userName = name;
  #   userEmail = email;
  #   lfs = {
  #     enable = true;
  #   };
  #   extraConfig = {
  #     init.defaultBranch = "main";
  #     core = {
  #       editor = "vim";
  #       autocrlf = "input";
  #     };
  #     commit.gpgsign = true;
  #     pull.rebase = true;
  #     rebase.autoStash = true;
  #   };
  # };

  # ssh = {
  #   enable = false;
  #
  #   extraConfig = lib.mkMerge [
  #     ''
  #       Host github.com
  #         Hostname github.com
  #         IdentitiesOnly yes
  #     ''
  #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #       ''
  #         IdentityFile /home/${user}/.ssh/id_github
  #       '')
  #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #       ''
  #         IdentityFile /Users/${user}/.ssh/id_github
  #       '')
  #   ];
  # };
}
