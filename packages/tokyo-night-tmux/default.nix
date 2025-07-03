{
  lib,
  pkgs,
  ...
}: let
  buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in
  buildTmuxPlugin {
    pluginName = "tokyo-night-tmux";
    rtpFilePath = "tokyo-night.tmux";
    version = "1.6.6";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "v1.6.6";

      hash = null;
    };
    # local copy for development
    # src = builtins.fetchGit {
    #   url = "file:///Users/plindsay/Code/make/tokyo-night-tmux";
    # };
    nativeBuildInputs = [pkgs.makeWrapper];
    postInstall = ''
      for f in $target/src/*.sh; do
        test -x $f && wrapProgram $f \
          --prefix PATH : ${
        with pkgs;
          lib.makeBinPath [bash bc coreutils gawk gh glab jq nowplaying-cli]
      }
      done
    '';
    meta = with lib; {
      homepage = "https://github.com/janoamaral/tokyo-night-tmux";
      description = "A clean, dark Tmux theme that celebrates the lights of Downtown Tokyo at night.";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [redyf];
    };
  }
