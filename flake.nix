
{
  description = "Starter Configuration for NixOS and MacOS";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  # , nixpkgs-unstable
  , disko
  , agenix
  } @inputs:
    let
      user = "plindsay";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" ];
      forAllLinuxSystems = f: nixpkgs.lib.genAttrs linuxSystems (system: f system);
      forAllDarwinSystems = f: nixpkgs.lib.genAttrs darwinSystems (system: f system);
      # forAllDarwinSystemsUnstable = f: nixpkgs-unstable.lib.genAttrs darwinSystems (system: f system);
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      # forAllSystemsUnstable = f: nixpkgs-unstable.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      devShell = system: let
        pkgs = nixpkgs.legacyPackages.${system};
        # pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      in
      {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=nvim
          '';
        };
        # default = with [ pkgs pkgs-unstable ]; mkShell {
        #   nativeBuildInputs = with [ pkgs pkgs-unstable ]; [ bashInteractive git age age-plugin-yubikey ];
        #   shellHook = with [ pkgs pkgs-unstable ]; ''
        #     export EDITOR=nvim
        #   '';
        # };
      };
    in
    {
      # devShells = (forAllSystemsUnstable) devShell;
      devShells = (forAllSystems) devShell;
      darwinConfigurations = let user = "plindsay"; in {
        macos = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = inputs;
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              nix-homebrew = {
                enable = true;
                user = "${user}";
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
        };
      };
     #  nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.nixosSystem {
     #    system = system;
     #    specialArgs = inputs;
     #    modules = [
     #      disko.nixosModules.disko
     #      home-manager.nixosModules.home-manager {
     #        home-manager.useGlobalPkgs = true;
     #        home-manager.useUserPackages = true;
     #        home-manager.users.${user} = import ./nixos/home-manager.nix;
     #      }
     #      ./nixos
     #    ];
     # });
  };
}
