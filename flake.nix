
{
  description = "Starter Configuration for NixOS and MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secrets = {
    #   url = "git+ssh://git@github.com/tlindsay/daystrom-station.git";
    #   flake = false;
    # };
    # Add `secrets` to outputs when ready
  };
  outputs = { self
  , darwin
  , nix-homebrew
  , homebrew-bundle
  , homebrew-core
  , homebrew-cask
  , home-manager
  , nixpkgs
  , disko
  , agenix
  } @inputs:
    let
      hostmap = {
        "fastbook" = {
          system = "aarch64-darwin";
          user = "plindsay";
        };
        "delta-flyer" = {
          system = "aarch64-darwin";
          user = "pat";
        };
      };
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" ];
      forAllLinuxSystems = f: nixpkgs.lib.genAttrs linuxSystems (system: f system);
      forAllDarwinSystems = f: nixpkgs.lib.genAttrs darwinSystems (system: f system);
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      devShell = system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive neovim git age age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=nvim
          '';
        };
      };
      hostpkgs = system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        delta-flyer = with pkgs; [
          # super-slicer-beta
          arduino-cli
          avrdude
          esptool
          openscad
          steam
        ];
      };
    in
    {
      devShells = (forAllDarwinSystems) devShell;
      darwinConfigurations = builtins.mapAttrs
        (hn: conf: darwin.lib.darwinSystem {
         system = conf.system;
         specialArgs = {
           inherit inputs;
           user = conf.user;
           hostpkgs = (hostpkgs conf.system).${hn};
         };
         modules = [
           nix-homebrew.darwinModules.nix-homebrew
           home-manager.darwinModules.home-manager
           {
             home-manager.extraSpecialArgs = { user = conf.user; };
             nix-homebrew = {
               enable = true;
               user = "${conf.user}";
               taps = {
                 "homebrew/homebrew-core" = homebrew-core;
                 "homebrew/homebrew-cask" = homebrew-cask;
                 "homebrew/homebrew-bundle" = homebrew-bundle;
               };
               mutableTaps = false;
               autoMigrate = true;
             };
           }
           ./darwin
         ];
        }
      ) hostmap;
    };
}
