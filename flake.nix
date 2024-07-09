{
  description = "Starter Configuration for NixOS and MacOS";

  # nixConfig = {
  #   extra-substituters = [
  #     # "https://ghostty.cachix.org/"
  #     "https://nix-community.cachix.org/"
  #   ];
  #
  #   extra-trusted-public-keys = [
  #     # "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #   ];
  # };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
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
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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
    homebrew-infra = {
      url = "github:infrahq/homebrew-tap";
      flake = false;
    };
    homebrew-tako8ki = {
      url = "github:TaKO8Ki/homebrew-tap";
      flake = false;
    };
    # Slumber is a REST TUI
    homebrew-slumber = {
      url = "github:LucasPickering/homebrew-tap";
      flake = false;
    };
    # Vacuum is an OpenAPI linter/toolkit
    homebrew-vacuum = {
      url = "github:daveshanley/homebrew-vacuum";
      flake = false;
    };
    # jnv is an interactive filter builder for jq
    # homebrew-dbui = {
    #   url = "github:kenanbek/dbui";
    #   flake = false;
    # };
    # nix-inspect is a ranger-like TUI for inspecting your nixos config and other arbitrary nix expressions.
    nix-inspect.url = "github:bluskript/nix-inspect";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # ghostty = {
    #   url = "git+ssh://git@github.com/mitchellh/ghostty";
    # };
    # secrets = {
    #   url = "git+ssh://git@github.com/tlindsay/daystrom-station.git";
    #   flake = false;
    # };
    # Add `secrets` to outputs when ready
  };
  outputs = inputs:
    with inputs; let
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
      linuxSystems = ["x86_64-linux" "aarch64-linux"];
      darwinSystems = ["aarch64-darwin"];
      forAllLinuxSystems = f:
        nixpkgs.lib.genAttrs linuxSystems (system: f system);
      forAllDarwinSystems = f:
        nixpkgs.lib.genAttrs darwinSystems (system: f system);
      forAllSystems = f:
        nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      devShell = system: let
        pkgs = import nixpkgs {
          system = "${system}";
          config.allowUnfree = true;
        };
        # pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = with pkgs;
          mkShell {
            nativeBuildInputs = with pkgs; [
              bashInteractive
              neovim
              git
              age
              age-plugin-yubikey
            ];
            shellHook = with pkgs; ''
              export EDITOR=nvim
            '';
          };
      };
      hostpkgs = system: let
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };
      in {
        delta-flyer = with pkgs; [
          # super-slicer-beta
          arduino-cli
          avrdude
          esptool
          openscad
        ];
        fastbook = with pkgs; [
          google-cloud-sdk
          openapi-tui
          tilt
        ];
      };
    in {
      devShells = forAllDarwinSystems devShell;
      darwinConfigurations = builtins.mapAttrs (hn: conf:
        darwin.lib.darwinSystem {
          system = conf.system;
          specialArgs = {
            inherit inputs;
            user = conf.user;
            hostpkgs = (hostpkgs conf.system).${hn};
            hostname = hn;
          };
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = {user = conf.user;};
              nix-homebrew = {
                enable = true;
                user = "${conf.user}";
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "infrahq/tap" = homebrew-infra;
                  "tako8ki/tap" = homebrew-tako8ki;
                  "lucaspickering/tap" = homebrew-slumber;
                  "daveshanley/vacuum" = homebrew-vacuum;
                  # "kenanbek/dbui" = homebrew-dbui;
                };
                mutableTaps = true;
                autoMigrate = true;
              };
            }
            ./darwin
          ];
        })
      hostmap;
    };
}
