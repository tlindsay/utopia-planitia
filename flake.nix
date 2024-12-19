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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    homebrew-dagger = {
      url = "github:dagger/homebrew-tap";
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
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      channels-config = {
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = false;
        allowUnsupportedSystem = true;
      };
      src = ./.;
      snowfall = { namespace = "replicator"; };
    };
}
