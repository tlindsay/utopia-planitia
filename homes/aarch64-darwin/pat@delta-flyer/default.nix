{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "24.11";
  };
}
