_: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.ds1.federation.space";
    };
  };
}
