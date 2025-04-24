{pkgs, ...}: let
  username = "pat";
in {
  networking.hostName = "subspace-relay";
  snowfallorg.users.${username} = {
    admin = true;
  };
  users.users.${username} = {
    isHidden = false;
    description = "Patrick Lindsay";
    shell = pkgs.zsh;
    extraGroups = ["docker"];
  };

  system.stateVersion = 4;
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    # oci-containers = {
    #   musiccast2mqtt = {
    #     image = "jme24/musiccast2mqtt:latest";
    #     ports = ["41100:41100/udp"];
    #
    #   };
    # };
  };
}
