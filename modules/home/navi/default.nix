{pkgs, ...}: {
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.navi;
  };
}
