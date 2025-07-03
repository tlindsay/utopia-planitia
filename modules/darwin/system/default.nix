{config, ...}: let
  user = builtins.head (builtins.attrNames config.snowfallorg.users);
in {
  # environment.darwinConfig = "${config.system.primaryUserHome}/.nixpkgs/darwin-configuration.nix";
  system = {
    primaryUser = "${user}";
    checks = {verifyNixPath = false;};

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleInterfaceStyleSwitchesAutomatically = true;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.65;
        "com.apple.sound.beep.feedback" = 1;
      };

      # dock = {
      #   autohide = true;
      #   show-recents = false;
      #   launchanim = true;
      #   orientation = "bottom";
      #   tilesize = 72;
      # };

      finder = {
        _FXShowPosixPathInTitle = false;
        FXPreferredViewStyle = "clmv";
      };

      screencapture.location = "~/Pictures/Screenshots";

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerTapGesture = 0;
      };
    };

    keyboard = {enableKeyMapping = true;};

    stateVersion = 4;
  };
}
