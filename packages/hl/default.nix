{pkgs, ...}:
with pkgs;
  rustPlatform.buildRustPackage rec {
    pname = "hl";
    version = "v0.29.8";

    src = fetchFromGitHub {
      owner = "pamburus";
      repo = "hl";
      rev = "v0.29.8";
      sha256 = null;
    };

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        # Still no fucking clue how to properly get these hashes
        "htp-0.4.2" = "sha256-oYLN0aCLIeTST+Ib6OgWqEgu9qyI0n5BDtIUIIThLiQ=";
        "wildflower-0.3.0" = "sha256-vv+ppiCrtEkCWab53eutfjHKrHZj+BEAprV5by8plzE=";
      };
    };

    meta = {
      description = "A fast and powerful log viewer and processor that translates JSON or logfmt logs into a pretty human-readable format. High performance and convenient features are the main goals.";
      homepage = "https://github.com/pamburus/hl";
      license = lib.licenses.mit;
      maintainers = [];
    };
  }
