{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    colima
    dockutil
    imagemagick
    reattach-to-user-namespace
    yadm
  ]
