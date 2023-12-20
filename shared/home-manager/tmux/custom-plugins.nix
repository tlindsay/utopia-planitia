{ lib, pkgs, ... }:
let buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in {
  session-wizard = buildTmuxPlugin {
    pluginName = "session-wizard";
    version = "1.1.0";
    rtpFilePath = "session-wizard.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "27medkamal";
      repo = "tmux-session-wizard";
      rev = "a61962def77db987833c4245e95f60eb1944ceae";
      sha256 = null;
    };
  };

  open-nvim = buildTmuxPlugin {
    pluginName = "open-nvim";
    version = "unstable-2023-11-15";
    rtpFilePath = "tmux_open_nvim.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "trevarj";
      repo = "tmux-open-nvim";
      rev = "fbbe55bf49cbbbc497b8c044957f9b7bfeb0a93c";
      sha256 = null;
    };
  };

  cowboy = buildTmuxPlugin {
    pluginName = "cowboy";
    version = "unstable-2021-05-11";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cowboy";
      rev = "75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      sha256 = null;
    };
  };

  tmux-menus = buildTmuxPlugin {
    pluginName = "tmux-menus";
    version = "unstable-2023-10-09";
    rtpFilePath = "menus.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "jaclu";
      repo = "tmux-menus";
      rev = "764ac9cd6bbad199e042419b8074eda18e9d8b2d";
      sha256 = null;
    };
  };
}
