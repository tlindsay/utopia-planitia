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
      iina # "Modern media player for macOS"
      imagemagick
      karabiner-elements
      monitorcontrol
      nix-inspect
      qemu
      reattach-to-user-namespace
      yadm
    ];
  }
