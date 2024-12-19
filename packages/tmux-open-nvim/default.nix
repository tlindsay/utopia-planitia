{ pkgs, ... }:
let buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in buildTmuxPlugin {
  pluginName = "open-nvim";
  version = "unstable-2024-10-09";
  rtpFilePath = "tmux_open_nvim.tmux";
  src = pkgs.fetchFromGitHub {
    owner = "trevarj";
    repo = "tmux-open-nvim";
    rev = "1770943b651160374b90080d92b83e6a503c4dff";
    sha256 = null;
  };
  postInstall = ''
    mkdir -p $out/bin
    cp $target/scripts/ton $out/bin
    chmod +x $out/bin/ton
  '';
}
