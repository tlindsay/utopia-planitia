_: {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "none";
      autoUpdate = true;
      upgrade = true;
      extraFlags = [
        "--verbose"
      ];
    };
    taps = [
      "infrahq/homebrew-tap"
      "TaKO8Ki/homebrew-tap" # gobang - DBMS TUI
      "LucasPickering/homebrew-tap" # slumber - REST client TUI
      "daveshanley/homebrew-vacuum" # vacuum - OpenAPI linter
      "dagger/homebrew-tap" # dagger build pipelines
    ];
    brews = [
      "blueutil"
      "fileicon"
      "otree"
      "infra"
      "gobang"
      "slumber"
      "vacuum"
      "dagger"
    ];
    casks = [
      # Development Tools
      "apparency"
      "bruno"

      # Utility Tools
      "betterdisplay"
      "qmk-toolbox"
      "linearmouse"

      # Entertainment
      "radiola"
    ];
    masApps = {
      "wireguard" = 1451685025;
      "easyres" = 688211836;
      "sequel-ace" = 1518036000;
      "yamacast-musiccast-remote" = 1415107621;
    };
  };
}
