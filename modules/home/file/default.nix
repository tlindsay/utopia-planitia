{pkgs, ...}: {
  home.file = {
    ".default-golang-pkgs".text = builtins.readFile ../../../dotfiles/default-golang-pkgs;
    ".claude/settings.json".text = builtins.readFile ../../../dotfiles/claude/settings.json;
    ".claude/CLAUDE.md".text = builtins.readFile ../../../dotfiles/ai.md;
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
      ".config/opencode/AGENTS.md".text = builtins.readFile ../../../dotfiles/ai.md;
      "direnv/lib/oprc.sh".source =
        pkgs.replicator.direnv-oprc;
      "ghostty/shaders" = let
        inherit (pkgs) stdenv fetchFromGitHub symlinkJoin;

        shaders1 = stdenv.mkDerivation {
          name = "ghostty-shaders-github";
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

        shaders2 = stdenv.mkDerivation {
          name = "ghostty-shaders-github";
          src = fetchFromGitHub {
            owner = "KroneCorylus";
            repo = "ghostty-shader-playground";
            rev = "main";
            sha256 = null;
          };

          buildPhase = null;
          installPhase = ''
            mkdir -p $out
            cp shaders/*.glsl $out
          '';
        };
      in {
        recursive = true;
        source = symlinkJoin {
          name = "ghostty-shaders";
          paths = [
            shaders1
            shaders2
          ];
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
