{
  description = "Starter Configuration for NixOS and MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # The name "snowfall-lib" is required due to how Snowfall Lib processes your
    # flake's inputs.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust toolchains (rustup replacement for nix)
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-inspect is a ranger-like TUI for inspecting your nixos config and other arbitrary nix expressions.
    nix-inspect.url = "github:bluskript/nix-inspect";

    # Declarative disk partitioning and formatting using nix
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      channels-config = {
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = false;
        allowUnsupportedSystem = true;
      };
      src = ./.;
      snowfall = {namespace = "replicator";};
    };
}
