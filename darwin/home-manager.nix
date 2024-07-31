{
  config,
  pkgs,
  upkgs,
  inputs,
  lib,
  user,
  home-manager,
  ...
}: let
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
  additionalFiles = import ./files.nix {inherit user config pkgs;};
in {
  imports = [./dock ./homebrew.nix];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # These app IDs are from using the mas CLI app
  # mas = mac app store
  # https://github.com/mas-cli/mas
  #
  # $ nix shell nixpkgs#mas
  # $ mas search <app name>
  #
  homebrew.masApps = {
    "wireguard" = 1451685025;
    "easyres" = 688211836;
    "sequel-ace" = 1518036000;
    "yamacast-musiccast-remote" = 1415107621;
  };

  # Enable home-manager
  home-manager = {
    backupFileExtension = "nix.bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }:
      {
        home = {
          enableNixpkgsReleaseCheck = true;
          packages = pkgs.callPackage ./packages.nix {inherit upkgs;};
          file = lib.mkMerge [sharedFiles additionalFiles];

          stateVersion = "24.05";
        };

        fonts.fontconfig.enable = true;
        # services.ssh-agent.enable = true;
        programs = {
          home-manager = {enable = true;};
          # bottom = {};
          # direnv = {};
          # eza = {};
          # fzf = {};
          # gh = {};
          # go = {};
          # gpg = {};
          # kitty = {};
          # k9s = {};
          # lazygit = {};
          # neovim = {};
          # ripgrep = {};
          # starship = {};
          # tealdeer = {};
          # tmux = {};
          # zoxide = {};
          #
          # # sqls = {}; # INVESTIGATE!!!
        };
      }
      // import ../shared/home-manager/default.nix {
        inherit config inputs pkgs upkgs lib user;
      };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    {path = "/Applications/Arc.app/";}
    {path = "/System/Applications/Messages.app/";}
    (lib.mkIf (config.networking.hostName == "fastbook") {
      path = "/Applications/Slack.app/";
    })
    (lib.mkIf (config.networking.hostName == "delta-flyer") {
      path = "${pkgs.discord}/Applications/Discord.app/";
    })
    {path = "/Applications/Setapp/Canary Mail.app/";}
    {path = "/Applications/Ghostty.app/";}
    {path = "/Applications/Spotify.app/";}
    (lib.mkIf (config.networking.hostName == "delta-flyer") {
      path = "/Applications/Steam.app/";
    })
    {
      path = "${config.users.users.${user}.home}/Pictures/Screenshots";
      section = "others";
      options = "--sort dateadded --view grid --display stack";
    }
    {
      path = "${config.users.users.${user}.home}/Downloads";
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
  ];
}
