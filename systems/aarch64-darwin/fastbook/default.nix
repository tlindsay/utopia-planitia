{ pkgs, ... }: {
  # snowfallorg.users.plindsay = {
  #   create = false;
  #   admin = true;
  #
  #   home = { enable = true; };
  # };
  networking.hostName = "fastbook";
  users.users.plindsay = {
    isHidden = false;
    description = "Patrick Lindsay";
    shell = pkgs.zsh;
  };

  system.stateVersion = 4;
}
