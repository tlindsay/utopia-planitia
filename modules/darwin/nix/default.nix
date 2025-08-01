{
  config,
  inputs,
  pkgs,
  ...
}: let
  user = builtins.head (builtins.attrNames config.snowfallorg.users);
in {
  nix = {
    registry = {nixpkgs = {flake = inputs.nixpkgs;};};

    # nixPath = [
    #   {darwin-config = "${config.environment.darwinConfig}";}
    #   "nixpkgs=${inputs.nixpkgs.outPath}"
    #   "nixpkgs-unstable=${inputs.nixpkgs-unstable.outPath}"
    #   "nixos-config=/etc/nixos/configuration.nix"
    # ];

    package = pkgs.nixVersions.latest;

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];

      trusted-users = ["@admin" "${user}"];

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://utopia-planitia.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "utopia-planitia.cachix.org-1:gYfPaPCNPIQVbEatv3ysS1N/IMYNaJoNknj/Ttr8eoI="
      ];
    };

    gc = {
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
