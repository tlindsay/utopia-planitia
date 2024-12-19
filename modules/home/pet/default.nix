{pkgs, ...}: {
  programs.pet = {
    enable = true;
    selectcmdPackage = pkgs.fzf;
    settings = {};
    snippets = [];
  };
}
