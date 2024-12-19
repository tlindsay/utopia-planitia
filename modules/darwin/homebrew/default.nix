{...}: {
  homebrew = {
    enable = true;
    brews = [
      "blueutil"
      "fileicon"
      "otree"
      "infrahq/tap/infra"
      "tako8ki/tap/gobang"
      "LucasPickering/tap/slumber"
      "daveshanley/vacuum/vacuum"
      "dagger/tap/dagger"
    ];
    casks = [
      # Development Tools
      "apparency"
      "bruno"
      "linearmouse"

      # Utility Tools
      "betterdisplay"
      "qmk-toolbox"
      "linearmouse"
      # "setapp"

      # Productivity Tools
      # "raycast"

      # Browsers
      # "arc"
      # "google-chrome"
      # "firefox"
      # "homebrew/cask-versions/firefox-developer-edition"
    ];
    masApps = {
      "wireguard" = 1451685025;
      "easyres" = 688211836;
      "sequel-ace" = 1518036000;
      "yamacast-musiccast-remote" = 1415107621;
    };
  };
}
