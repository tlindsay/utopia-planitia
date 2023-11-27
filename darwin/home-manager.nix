{ config, pkgs, lib, home-manager, ... }:

let
  user = "plindsay";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew.enable = true;
  homebrew.casks = pkgs.callPackage ./casks.nix {};

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
    users.${user} = { pkgs, config, lib, ... }:{
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix {};
      home.file = lib.mkMerge [
        sharedFiles
        additionalFiles
      ];

      home.stateVersion = "21.11";
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Arc.app/"; }
    { path = "/System/Applications/Messages.app/"; }
    { path = "/Applications/Slack.app/"; }
    { path = "/Applications/Setapp/Canary Mail.app/"; }
    { path = "${pkgs.kitty}/Applications/kitty.app/"; }
    { path = "/Applications/Spotify.app/"; }
    {
      path = "${config.users.users.${user}.home}/Screenshots";
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
