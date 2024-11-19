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

  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
      package = upkgs.atuin;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://atuin.ds1.federation.space";
      };
    };

    bat = {
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

    navi = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs.navi;
    };

    nushell = {
      enable = true;
    };

    k9s = {
      enable = true;
      settings = {
        k9s = {
          liveViewAutoRefresh = true;
        };
      };
      plugin = {
        plugins = {
          # Sends logs over to jq for processing. This leverages kubectl plugin kubectl-jq.
          jqlogs = {
            shortCut = "Shift-J";
            confirm = false;
            description = "Logs (jq)";
            scopes = ["container"];
            background = false;
            command = "sh";
            args = [
              "-c"
              "kubectl logs -f $POD -c $NAME -n $NAMESPACE --context $CONTEXT | jq -SR '. as $line | try (fromjson) catch $line'"
            ];
          };
          nicelogs = {
            shortCut = "Shift-L";
            description = "Nice Logs (hl)";
            background = false;
            confirm = false;
            command = "bash";
            scopes = [
              "all"
            ];
            args = ["-c" "hl -F --tail 200 <(kubectl logs -f $POD -c $NAME -n $NAMESPACE --context $CONTEXT)"];
          };
        };
      };
    };

    pet = {
      enable = true;
      selectcmdPackage = pkgs.fzf;
      settings = {};
      snippets = [];
    };

    direnv = {
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

    nix-index = {
      enable = true;
    };
    command-not-found.enable = false;
  };

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
