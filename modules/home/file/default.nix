{
  home.file = {
    ".default-golang-pkgs" = {
      text = builtins.readFile ../../../dotfiles/default-golang-pkgs;
    };
  };
}
