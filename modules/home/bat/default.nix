{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = { theme = "tokyonight_moon"; };
    syntaxes = {
      jq = {
        src = pkgs.fetchFromGitHub {
          owner = "zogwarg";
          repo = "SublimeJQ";
          rev = "master";
          hash = null;
        };
        file = "JQ.sublime-syntax";
      };
    };
    themes = let
      tokyo = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "tokyonight.nvim";
        rev = "main";
        hash = null;
      };
    in {
      tokyonight_moon = {
        src = tokyo;
        file = "extras/sublime/tokyonight_moon.tmTheme";
      };
    };
  };
}

