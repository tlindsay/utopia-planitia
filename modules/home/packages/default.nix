{pkgs, ...}: {
  home = {
    enableNixpkgsReleaseCheck = true;
    packages = pkgs.callPackage ./packages.nix {inherit pkgs;};

    stateVersion = "24.11";
  };
}
