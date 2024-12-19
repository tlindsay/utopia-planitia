{ pkgs, ... }:
let buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in buildTmuxPlugin {
  pluginName = "tmux-menus";
  version = "unstable-2024-10-09";
  rtpFilePath = "menus.tmux";
  src = pkgs.fetchFromGitHub {
    owner = "jaclu";
    repo = "tmux-menus";
    rev = "ccdeb5ce70cdd343e0e51e343966620786a0de9a";
    sha256 = null;
  };
}
