{
  inputs,
  system,
  ...
}: let
  upkgs = inputs.nixpkgs-unstable.legacyPackages."${system}";
in {
  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
    tailscale = {
      enable = true;
      package = upkgs.tailscale;
    };
  };
}
