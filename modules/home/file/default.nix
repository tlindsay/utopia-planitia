{pkgs, ...}: {
  home.file = {
    ".default-golang-pkgs" = {
      text = builtins.readFile ../../../dotfiles/default-golang-pkgs;
    };
    ".claude/settings.json" = {
      text = builtins.readFile ../../../dotfiles/claude/settings.json;
    };
  };
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
      "ghostty/shaders" = let
        inherit (pkgs) stdenv fetchFromGitHub;
      in {
        recursive = true;
        source = stdenv.mkDerivation {
          name = "ghostty-shaders";
          src = fetchFromGitHub {
            owner = "hackr-sh";
            repo = "ghostty-shaders";
            rev = "main";
            sha256 = null;
          };

          buildPhase = null;
          installPhase = ''
            mkdir -p $out
            cp *.glsl $out
          '';
        };
      };
    };
    dataFile = {
      "bin" = {
        source = ../../../dotfiles/bin;
        recursive = true;
      };
    };
  };
}
