{
  inputs,
  system,
  ...
}: let
  upkgs = inputs.nixpkgs-unstable.legacyPackages."${system}";
in {
  services = {
    tailscale = {
      enable = true;
      package = upkgs.tailscale;
    };
  };
}
