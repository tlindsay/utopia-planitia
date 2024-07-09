{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    colima
    lima-bin
    dockutil
    imagemagick
    qemu
    reattach-to-user-namespace
    yadm
  ]
