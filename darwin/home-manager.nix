{ config, pkgs, inputs, lib, user, home-manager, ... }:

let
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
   ./homebrew.nix
  ];

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
    "easyres"   = 688211836;
    "yamacast-musiccast-remote" = 1415107621;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix {};
      home.file = lib.mkMerge [
        sharedFiles
        additionalFiles
      ];
      fonts.fontconfig.enable = true;

      home.stateVersion = "23.11";
      programs = {
        home-manager = { enable = true; };
      };
    } // import ../shared/home-manager/default.nix { inherit config inputs pkgs lib user; };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Arc.app/"; }
    { path = "/System/Applications/Messages.app/"; }
    ( lib.mkIf (config.networking.hostName == "fastbook") { path = "/Applications/Slack.app/"; } )
    { path = "/Applications/Setapp/Canary Mail.app/";  }
    { path = "${pkgs.kitty}/Applications/kitty.app/"; }
    { path = "/Applications/Spotify.app/"; }
    ( lib.mkIf (config.networking.hostName == "delta-flyer") { path = "/Applications/Steam.app/"; } )
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
