{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    colima
    dockutil
    imagemagick
    qemu
    reattach-to-user-namespace
    spotify
    yadm
  ]

