{
  config,
  pkgs,
  ...
}: let
  home = config.snowfallorg.user.home.directory;
  xdg_configHome = "${home}/.config";
in {
  xdg = {
    enable = true;
    configFile = {
      # Do not change key. "." is important for plugging all the files into ~/.config
      "." = {
        source = ../../../dotfiles/config;
        recursive = true;
        target = "./";
      };
      ".default-golang-pkgs" = {
        text = builtins.readFile ../../../dotfiles/default-golang-pkgs;
      };
      "${xdg_configHome}/direnv/lib/oprc.sh".source =
        pkgs.replicator.direnv-oprc;
      "bins" = {
        source = ../../../dotfiles/bin;
        recursive = true;
        target = ".bin/";
      };
    };
  };
}
