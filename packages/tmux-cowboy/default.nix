{pkgs, ...}: let
  buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in
  buildTmuxPlugin {
    pluginName = "cowboy";
    version = "unstable-2021-05-11";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cowboy";
      rev = "75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      sha256 = null;
    };
  }
