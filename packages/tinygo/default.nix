{pkgs, ...}:
with pkgs;
  buildGoModule rec {
    pname = "tinygo";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "tinygo-org";
      repo = "tinygo";
      rev = "latest";
      sha256 = null;
    };
  }
