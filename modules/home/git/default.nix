{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.git;

    userName = "Patrick Lindsay";
    userEmail = "plindsay@fastly.com";

    ignores = [
      ".tool-versions"
      "Session.vim"
      ".DS_Store"
      "npm-debug.log"
      "yarn-error.log"
    ];

    includes = [
      {
        condition = "gitdir:~/Code/work/";
        contents = {
          user = {
            email = "plindsay@fastly.com";
            protcol = "ssh";
            signingkey = "73113FF74AF34375";
          };
          commit = {
            gpgsign = true;
          };
        };
      }
    ];

    diff-so-fancy = {
      enable = false; # Manually enabled in extraConfig.core.pager for use with `bat`
      rulerWidth = 50;
    };

    extraConfig = {
      # EXPERIMENTAL
      commit = {verbose = true;};
      diff = {
        colorMoved = "plain";
        algorithm = "histogram";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        all = true;
        prune = true;
        pruneTags = true;
      };
      help = {autocorrect = "prompt";};
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      tag = {sort = "refname";};
      # END EXPERIMENTS

      checkout = {defaultRemote = "origin";};
      core = {
        pager = "diff-so-fancy | bat --style=numbers";
        fsmonitor = false;
      };
      gui = {
        warndetachedcommit = true;
      };
      hub = {
        protocol = "https";
      };
      init = {defaultBranch = "main";};
      interactive = {diffFilter = "diff-so-fancy --patch";};
      maintenance = {
        repo = [
          "/Users/plindsay/Code/work/fastly/fst-observe-api"
          "/Users/plindsay/Code/work/fastly/fst-events"
          "/Users/plindsay/Code/work/fastly/fst-alerts"
        ];
      };
      push = {autoSetupRemote = true;};
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      user.protocol = "ssh";
    };
  };
}
