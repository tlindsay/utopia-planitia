{pkgs, ...}: {
  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
    tailscale = {
      enable = true;
      package = pkgs.tailscale;
    };
  };
}
