{
  pkgs,
  inputs,
  system,
  ...
}: let
  upkgs = inputs.nixpkgs-unstable.legacyPackages."${system}";
in {
  home.packages = with pkgs; [
    upkgs.claude-code
    rpi-imager
  ];
}
