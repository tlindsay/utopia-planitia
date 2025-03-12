{
  config,
  inputs,
  pkgs,
  ...
}: let
  user = builtins.head (builtins.attrNames config.snowfallorg.user);
in {
  nix = {
    registry = {nixpkgs = {flake = inputs.nixpkgs;};};

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    package = pkgs.nixVersions.latest;
    settings.trusted-users = ["@admin" "${user}"];

    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
