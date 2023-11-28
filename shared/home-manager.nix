{ config, pkgs, lib, ... }:

let name = "Patrick Lindsay";
    user = "plindsay";
    email = "pat@thatdarnpat.com"; in
{
  # Shared shell configuration
  zsh.enable = false;
  zsh.autocd = true;
  zsh.cdpath = [ "~/.local/share/src" ];
  zsh.plugins = [];
  zsh.initExtraFirst = ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi

    # # Define variables for directories
    # export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
    # export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
    export PATH=$HOME/.local/share/bin:$PATH
    # export PNPM_HOME=~/.pnpm-packages

    # Remove history data we don't want to see
    export HISTIGNORE="pwd:ls:cd"

    # nix shortcuts
    shell() {
        nix-shell '<nixpkgs>' -A "$1"
    }
  '';

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  ssh = {
    enable = false;

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          IdentitiesOnly yes
      ''
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        ''
          IdentityFile /home/${user}/.ssh/id_github
        '')
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        ''
          IdentityFile /Users/${user}/.ssh/id_github
        '')
    ];
  };
}
