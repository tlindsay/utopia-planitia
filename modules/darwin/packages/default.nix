{
  inputs,
  pkgs,
  system,
  ...
}: let
  nix-inspect = inputs.nix-inspect.packages."${system}".default;
in
  with pkgs; {
    environment.systemPackages = [
      colima
      lima-bin
      dockutil
      imagemagick
      monitorcontrol
      nix-inspect
      qemu
      reattach-to-user-namespace
    ];
  }
