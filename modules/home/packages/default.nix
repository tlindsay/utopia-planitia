{pkgs, ...}: {
  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "24.11";
    packages = import ./packages.nix {inherit pkgs;};
  };
}
