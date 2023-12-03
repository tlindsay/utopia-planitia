{ lib, pkgs, ... }:

let
  buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in
{
  session-wizard = buildTmuxPlugin {
    pluginName = "session-wizard";
    version = "1.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "27medkamal";
      repo = "tmux-session-wizard";
      rev = "a61962def77db987833c4245e95f60eb1944ceae";
      sha256 = null;
    };
  };
  # open-nvim = buildTmuxPlugin {
  #   pluginName = "open-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "trevarj";
  #     repo = "tmux-open-nvim";
  #     rev = "fbbe55bf49cbbbc497b8c044957f9b7bfeb0a93c";
  #     sha256 = null;
  #   };
  # };
  # nord = buildTmuxPlugin {
  #   pluginName = "nord";
  #   version = "v0.3.0";
  #   src = lib.fetchTarball {
  #     name = "Nord-Tmux-2020-08-25";
  #     url = "https://github.com/arcticicestudio/nord-tmux/archive/4e2dc2a5065f5e8e67366700f803c733682e8f8c.tar.gz";
  #     sha256 = "0l97cqbnq31f769jak31ffb7bkf8rrg72w3vd0g3fjpq0717864a";
  #   };
  # };
}
