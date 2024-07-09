{...}: {
  homebrew = {
    enable = true;
    brews = [
      "blueutil"
      "fileicon"
      "infrahq/tap/infra"
      "tako8ki/tap/gobang"
      "LucasPickering/tap/slumber"
      "daveshanley/vacuum/vacuum"
    ];
    casks = [
      "apparency"
      "qmk-toolbox"
      # # Development Tools
      # "1password"
      # "bruno"
      # "scroll-reverser"
      # "trailer"
      #
      # # # Fonts
      # # "homebrew/cask-fonts/font-commit-mono-nerd-font"
      # # "homebrew/cask-fonts/font-fantasque-sans-mono"
      # # "homebrew/cask-fonts/font-fantasque-sans-mono-nerd-font"
      # # "homebrew/cask-fonts/font-monaspace-nerd-font"
      # # "homebrew/cask-fonts/font-symbols-only-nerd-font"
      #
      # # Communication Tools
      # "slack"
      # "zoom"
      #
      # # Utility Tools
      # "hammerspoon"
      # "setapp"
      #
      # # Entertainment Tools
      # "spotify"
      #
      # # Productivity Tools
      # "raycast"
      #
      # # Browsers
      # "arc"
      # "google-chrome"
      # "firefox"
      # "homebrew/cask-versions/firefox-developer-edition"
    ];
  };
}
