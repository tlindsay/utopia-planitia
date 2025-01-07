{pkgs, ...}: {
  home = {
    enableNixpkgsReleaseCheck = true;
    packages = import ./packages.nix {inherit pkgs;};

    stateVersion = "24.11";
  };
}
