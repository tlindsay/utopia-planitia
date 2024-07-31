{
  pkgs,
  upkgs,
}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs upkgs;};
in
  shared-packages
  ++ [
    colima
    lima-bin
    dockutil
    imagemagick
    monitorcontrol
    qemu
    reattach-to-user-namespace
    yadm
  ]
