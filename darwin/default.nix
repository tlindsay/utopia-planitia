{
  inputs,
  config,
  pkgs,
  upkgs,
  lib,
  hostpkgs,
  hostname,
  user,
  ...
}: let
  agenix = inputs.agenix;
  nix-inspect = inputs.nix-inspect;
  # ghostty = inputs.ghostty;
in {
  imports = [
    # ./secrets.nix
    ./home-manager.nix
    ../shared
    ../shared/cachix
    agenix.darwinModules.default
  ];

  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
    tailscale = {
      enable = true;
      package = upkgs.tailscale;
    };
  };

  networking = {
    hostName = hostname;
    knownNetworkServices = ["Wi-Fi" "Thunderbolt Ethernet Slot 0"];
    dns = [
      # Tailscale
      "100.100.100.100"
      # NextDNS
      "45.90.28.65"
      "45.90.30.65"
      "2a07:a8c0::9c:b526"
      "2a07:a8c1::9c:b526"
      # Fallback
      "9.9.9.9"
    ];
  };

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

    package = pkgs.nixVersions.latest;
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
  environment.systemPackages =
    [
      agenix.packages."${pkgs.system}".default
      nix-inspect.packages."${pkgs.system}".default
      # ghostty.packages."${pkgs.system}".ghostty
    ]
    ++ hostpkgs
    ++ (import ./packages.nix {inherit pkgs upkgs;});

  security.pam.enableSudoTouchIdAuth = true;
  system = {
    stateVersion = 4;

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

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 72;
      };

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
