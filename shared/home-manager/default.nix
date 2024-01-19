{
  config,
  pkgs,
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

  programs.nushell = {
    enable = true;
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
