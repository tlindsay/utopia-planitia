{pkgs, ...}: {
  xdg = {
    enable = true;
    configFile = {
      # Do not change key. "." is important for plugging all the files into ~/.config
      "." = {
        source = ../../../dotfiles/config;
        recursive = true;
        target = "./";
      };
      "direnv/lib/oprc.sh".source =
        pkgs.replicator.direnv-oprc;
    };
    dataFile = {
      "bin" = {
        source = ../../../dotfiles/bin;
        recursive = true;
      };
    };
  };
}
