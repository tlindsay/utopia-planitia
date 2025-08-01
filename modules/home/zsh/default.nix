{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.snowfallorg) user;
in {
  home = {
    sessionPath = [
      "$HOME/.local/share/bin"
      "$HOME/.bin"
      "/usr/local/bin"
      "/usr/local/sbin"
      "$HOME/.nix-profile/sw/bin"
      "$HOME/go/bin"
    ];
  };
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (lib.readFile ./starship.toml);
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    # Shared shell configuration
    zsh = {
      enable = true;
      autocd = true;
      autosuggestion = {
        enable = true;
        strategy = ["history" "completion"];
      };
      cdpath = ["~/.local/share/src"];
      defaultKeymap = "viins";
      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignorePatterns = ["pwd *" "ls *" "cd *"];
        ignoreSpace = true;
        size = 50000;
        share = true;
      };

      initContent = let
        extraFirst = lib.mkOrder 500 ''
          # Ghostty shell integration for zsh. This should be at the top of your zshrc!
          if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
            builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
          fi

          if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          	. /nix/var/nix/profiles/default/etc/profile.d/nix.sh
          fi

          # Define variables for directories
          if [ -x "/opt/homebrew/bin/brew" ]; then
          	eval "$(/opt/homebrew/bin/brew shellenv)"
          elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
          	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
          fi

          # Only load ASDF if not already loaded
          if [[ -z "$ASDF_DIR" ]]; then
            export ASDF_CONFIG_FILE=$HOME/.config/asdfrc
            . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
            . ~/.asdf/plugins/golang/set-env.zsh
            export ASDF_GOLANG_MOD_VERSION_ENABLED=true
          fi

          # zsh-vi-mode config func
          function zvm_config() {
            ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
          }
        '';
        extraBeforeCompInit = lib.mkOrder 550 ''
          if type brew &>/dev/null && [[ -e $(brew --prefix)/share/zsh/site-functions ]]; then
            FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
          fi
          if [[ -d $HOME/.nix-profile/sw/share/zsh/site-functions ]]; then
            FPATH="$HOME/.nix-profile/sw/share/zsh/site-functions:$FPATH"
          fi
          if [[ -d /etc/profiles/per-user/${user.name}/share/zsh/site-functions ]]; then
            FPATH="/etc/profiles/per-user/${user.name}/share/zsh/site-functions:$FPATH"
          fi

          if antidote path 'wfxr/forgit' > /dev/null 2>&1; then
            FPATH="$(antidote path 'wfxr/forgit')/completions:$FPATH"
          fi

          autoload -Uz compinit && compinit
          autoload -Uz compaudit && compaudit
        '';
        extra = lib.mkOrder 1000 ''
          forgit_checkout_commit='gcco'

          bindkey '^ ' autosuggest-accept
          bindkey '^P' up-line-or-search
          bindkey '^N' down-line-or-search
          bindkey '^X' clear-screen

          # Set Cache Dir for dotenv plugin
          export ZSH_CACHE_DIR="$HOME/.local/cache"

          # Load machine specific configs, if available
          if [[ -a ~/.zprofile.local ]]; then
            source ~/.zprofile.local
          fi

          # Use 1Password ssh-agent if available
          if [[ -S "/Users/${user.name}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]; then
            export SSH_AUTH_SOCK="/Users/${user.name}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          fi
        '';
        after = lib.mkOrder 1500 ''
          if antidote path 'wfxr/forgit' > /dev/null 2>&1; then
            source $(antidote path 'wfxr/forgit')/completions/git-forgit.zsh
          fi
        '';
      in
        lib.mkMerge [extraFirst extraBeforeCompInit extra after];

      antidote = {
        enable = true;
        plugins = [
          "jeffreytse/zsh-vi-mode"

          "mdumitru/git-aliases kind:defer"
          "wfxr/forgit kind:defer"

          "nix-community/nix-zsh-completions kind:defer"

          "Aloxaf/fzf-tab kind:defer"
          "zdharma/fast-syntax-highlighting kind:defer"
          "zsh-users/zsh-autosuggestions kind:defer"
          "zsh-users/zsh-completions kind:defer"
          "junegunn/fzf path:shell/key-bindings.zsh kind:defer"
        ];
      };

      completionInit = ''
        # Set up tab-completions
        compinit -i -C -d ~/.zcompdump*

        # Arrow key menu for completions
        zstyle ':completion:*' menu select

        # Case-insensitive (all),partial-word and then substring completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        # fzf-tab configs
        # disable sort when completing `git checkout`
        zstyle ':completion:*:git-checkout:*' sort false
        # set descriptions format to enable group support
        zstyle ':completion:*:descriptions' format '[%d]'
        # preview directory's content with exa when completing cd
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
        # switch group using `,` and `.`
        zstyle ':fzf-tab:*' switch-group ',' '.'
      '';

      envExtra = ''
        export HOMEBREW_NO_ANALYTICS=1

        export PLAYDATE_SDK_PATH=~/Developer/PlaydateSDK
        export TMUX_FZF_LAUNCH_KEY="C-s"

        export VISUAL=nvim
        export EDITOR="$VISUAL"

        export MANROFFOPT="-c"
        export MANPAGER="moar"
        export PAGER="moar"

        export BAT_THEME="ansi"

        # Prevent zoxide from storing inaccurate PWDs (i.e., wrong caps)
        export _ZO_RESOLVE_SYMLINKS=1

        export FZF_DEFAULT_COMMAND="fd --type f --exclude '**/node_modules/*' --exclude '**/.git/*'"
        export FZF_DEFAULT_OPTS="
          --marker='󰄲 '
          --prompt=' '
          --pointer=' '
          --cycle
          --preview-window='right:60%'
          --bind 'alt-z:change-preview-window(right:90%|right:60%)'
          --bind='alt-k:preview-up,alt-p:preview-up'
          --bind='alt-j:preview-down,alt-n:preview-down'
          --bind='alt-s:toggle-sort'
          --bind='alt-w:toggle-preview-wrap'
        "
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --hidden"
        export FZF_CTRL_T_OPTS="--preview 'bat --style=header,changes,numbers --color=always {} | head -500'"

        export FORGIT_FZF_DEFAULT_OPTS="
          --ansi
          --border
          --cycle
          --reverse
        "

        export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"

        export GOTESTSUM_FORMAT="short"
        export GOTESTSUM_FORMAT_ICONS="octicons"

        export COMMA_PICKER="fzf"
      '';

      shellAliases = {
        l = "eza -1 -F --git --group-directories-first --icons=auto";
        ll = "eza -l -F --git --group-directories-first --icons=auto";
        lll = "ll --git -g --header -a";
        bathelp = "bat --plain --language=help";
        tree = "eza --tree";
        now = "date --utc +%FT%TZ";
        # .zshenv → .zprofile → .zshrc → .zlogin → .zlogout
        rz = "source ~/.zshenv && source ~/.zshrc && source ~/.zlogin && .zprofile.local && rehash";
        forgit = "alias | fzf -q forgit::";

        vpn = "(toggle-vpn && tmux refresh-client -S) &";
        nowrap = "tput rmam";
        wrap = "tput smam";

        # Use Raycast.app Spotify extension to "like" current song
        like = "open raycast://extensions/mattisssa/spotify-player/likeCurrentSong";
      };

      loginExtra = ''
        setopt CHASE_DOTS
        setopt CHASE_LINKS
        setopt EXTENDED_GLOB
        setopt INTERACTIVE_COMMENTS

        function zvm_after_init() {
          bindkey -M main '^R' atuin-search
        }

        # eval "$(${pkgs.navi} widget zsh)"

        function h() {
          "$@" --help 2>&1 | bathelp
        }

        function cd() {
          builtin cd $@
          l
        }

        # function v() {
        #   local job=$(jobs | perl -ne 'print $1 if /\[(\d+)\].*vim/')
        #   if [[ -n $job ]]; then
        #     tmux send-keys fg Space %$job Enter
        #     for f in $argv; do
        #       tmux send-keys :e Space `realpath $f` Enter
        #     done
        #   elif [[ ( -x $(which ton) ) && #argv[@] -gt 0 ]]; then
        #     ton $argv
        #   else
        #     vim $argv
        #   fi
        # }
        #
        # function o() {
        #   local job=$(jobs | perl -ne 'print $1 if /\[(\d+)\].*vim/')
        # }

        function toggle_vpn() {
          if [ "$1" != "" ]; then
            host="$1"
          else
            host="Corporate"
          fi

          vpn_status=$(scutil --nc status $host | sed -n 1p)

          if [ $vpn_status != "Connected" ]; then
            vpn_command="start"
          else
            vpn_command="stop"
          fi

          scutil --nc $vpn_command $host
        }

        function nettest() {
          if [ "$1" != "" ]; then
            host="$1"
          else
            host="8.8.8.8"
          fi
          ping -o "$host" && terminal-notifier -message "The internet is back!"
        }

        function randomSha() {
          local n = $1
          for i in `seq $n`; do od -vAn -N2 -tu2 < /dev/urandom | sha1sum; done
        }

        # Use nvim if available
        if type nvim > /dev/null 2>&1; then
          alias vim='nvim'
        fi
      '';
    };
  };
}
