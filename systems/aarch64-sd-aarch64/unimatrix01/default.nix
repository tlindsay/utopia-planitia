{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  networking.hostName = "unimatrix01";

  # Basic Raspberry Pi configuration
  hardware.enableRedistributableFirmware = true;

  # User configuration
  users.users.pat = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIPVm8Th0s4Op1on58R0Kvc7YTPv0INVXNHkpRjSKp3"
    ];
  };

  services = {
    # Enable SSH server
    openssh.enable = true;
    homebox = {
      enable = true;
      database.createLocally = true;
    };
    home-assistant.config.homeassistant = {
      name = "Alabama St";
      temperature_unit = "F";
      time_zone = "America/Chicago";
      unit_system = "us_customary";
      latitude = 34.79471;
      longitude = 87.68087;
    };
  };

  # Base system packages - minimal set to avoid cross-compilation issues
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # This sets the /boot/firmware partition which the Raspberry Pi needs
  sdImage.compressImage = true;

  system.stateVersion = "24.11";
}
