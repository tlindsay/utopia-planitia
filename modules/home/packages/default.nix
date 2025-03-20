{
  pkgs,
  inputs,
  system,
  ...
}: let
  upkgs = inputs.nixpkgs-unstable.legacyPackages."${system}";
in {
  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "24.11";
    packages = import ./packages.nix {inherit pkgs upkgs;};
  };
}
