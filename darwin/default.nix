{
  inputs,
  config,
  pkgs,
  hostpkgs,
  hostname,
  user,
  ...
}: let
  agenix = inputs.agenix;
  # ghostty = inputs.ghostty;
in {
  imports = [
    # ./secrets.nix
    ./home-manager.nix
    ../shared
    ../shared/cachix
    agenix.darwinModules.default
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  networking.hostName = hostname;

  # Setup user, packages, programs
  nix = {
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixUnstable;
    settings.trusted-users = ["@admin" "${user}"];

    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [
      agenix.packages."${pkgs.system}".default
      # ghostty.packages."${pkgs.system}".ghostty
    ]
    ++ hostpkgs
    ++ (import ./packages.nix {inherit pkgs;});

  # Enable fonts dir
  fonts.fontDir.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 72;
      };

      finder = {_FXShowPosixPathInTitle = false;};

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      # Handled in QMK now
      # TODO: Make this remap integrated keyboard, but leave external alone
      # remapCapsLockToControl = true;
      # userKeyMapping = [
      #   {
      #     # Remap Control To CapsLock
      #     HIDKeyboardModifierMappingSrc = 30064771296;
      #     HIDKeyboardModifierMappingDst = 30064771129;
      #   }
      # ];
    };
  };
}
