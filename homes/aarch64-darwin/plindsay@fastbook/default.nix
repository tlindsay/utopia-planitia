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

    clang
    lld
    openssl
    pkgconf

    mysql80
    vault
  ];
}
