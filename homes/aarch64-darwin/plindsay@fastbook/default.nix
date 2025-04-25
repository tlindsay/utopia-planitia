{
  inputs,
  pkgs,
  system,
  ...
}: let
  upkgs = inputs.nixpkgs-unstable.legacyPackages."${system}";
in {
  home.packages = with pkgs; [
    upkgs.google-cloud-sdk

    mysql80
    vault
  ];
}
