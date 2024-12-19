{
  lib,
  pkgs,
  ...
}: let
  buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in {
  open-nvim = buildTmuxPlugin {
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
  };

  tokyo-night-tmux = buildTmuxPlugin {
    pluginName = "tokyo-night-tmux";
    rtpFilePath = "tokyo-night.tmux";
    version = "1.5.5";
    src = pkgs.fetchFromGitHub {
      owner = "tlindsay";
      repo = "tokyo-night-tmux";
      rev = "b45b742eb3fdc01983c21b1763594b549124d065";

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
          --prefix PATH : ${with pkgs; lib.makeBinPath [bash bc coreutils gawk gh glab jq nowplaying-cli]}
      done
    '';
    meta = with lib; {
      homepage = "https://github.com/janoamaral/tokyo-night-tmux";
      description = "A clean, dark Tmux theme that celebrates the lights of Downtown Tokyo at night.";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [redyf];
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
    version = "unstable-2024-10-09";
    rtpFilePath = "menus.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "jaclu";
      repo = "tmux-menus";
      rev = "ccdeb5ce70cdd343e0e51e343966620786a0de9a";
      sha256 = null;
    };
  };
}
