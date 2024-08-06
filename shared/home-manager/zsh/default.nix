{
  config,
  pkgs,
  lib,
  user,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (lib.readFile ./starship.toml);
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  # Shared shell configuration
  programs.zsh = {
    enable = true;
    autocd = true;
    cdpath = ["~/.local/share/src"];
    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      	. /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/bin:/usr/local/bin:$PATH
      export PATH="/usr/local/sbin:$PATH"
      export PATH="$HOME/.nix-profile/sw/bin:$PATH"
      if [ -d "/opt/homebrew/bin" ]; then
      	eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
      	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      fi

      ## History file configuration
      [ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
      HISTSIZE=50000
      SAVEHIST=10000

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      ## History command configuration
      setopt extended_history       # record timestamp of command in HISTFILE
      setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
      setopt hist_ignore_dups       # ignore duplicated commands history list
      setopt hist_ignore_space      # ignore commands that start with space
      setopt hist_verify            # show command with history expansion to user before running it
      setopt inc_append_history     # add commands to HISTFILE in order of execution
      setopt share_history          # share command history data

      # load asdf
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh

      # asdf plugin specific configs
      . ~/.asdf/plugins/golang/set-env.zsh
      export ASDF_GOLANG_MOD_VERSION_ENABLED=true

      # zsh-vi-mode config func
      function zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
      }
    '';
    initExtraBeforeCompInit = ''
      # asdf shell completions
      fpath=($ASDF_DIR/completions $fpath)
      if type brew &>/dev/null && [[ -e $(brew --prefix)/share/zsh/site-functions ]]; then
        FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
      fi
      if [[ -e $HOME/.nix-profile ]]; then
        FPATH="$HOME/.nix-profile/share/zsh/site-functions:$FPATH"
      fi
      autoload -Uz compinit && compinit
      autoload -Uz compaudit && compaudit
    '';
    antidote = {
      enable = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"

        "mdumitru/git-aliases"
        "wfxr/forgit"

        "Aloxaf/fzf-tab"
        "zdharma/fast-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "junegunn/fzf path:shell/key-bindings.zsh"
      ];
    };
    completionInit = ''
      # Set up tab-completions
      compinit -i -C -d ~/.zcompdump*
      # set up app-specific completions
      eval "$(op completion zsh)"; compdef _op op
      eval "$(kubectl completion zsh)"; compdef _kubectl kubectl
      eval "$(atuin gen-completions --shell zsh); compdef _atuin atuin"
      eval "$(tailscale completion zsh); compdef _tailscale tailscale"

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
    initExtra = ''
      # Use nix-index for command-not-found
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

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

      # Add go binaries to PATH
      export PATH="$PATH:$HOME/go/bin"

      # Use 1Password ssh-agent if available
      if [[ -S "/Users/${user}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]; then
        export SSH_AUTH_SOCK="/Users/${user}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      fi
    '';

    loginExtra = ''
      export VISUAL=nvim
      export EDITOR="$VISUAL"

      export HOMEBREW_NO_ANALYTICS=1

      export BAT_THEME="ansi"
      export MANROFFOPT="-c"
      export MANPAGER="sh -c 'col -bx | bat -l man -p --color=always'"

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
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} | head -500'"

      export FORGIT_FZF_DEFAULT_OPTS="
        --ansi
        --border
        --cycle
        --reverse
      "

      export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

      function zvm_after_init() {
        bindkey -M main '^R' atuin-search
      }

      alias l="eza -1 -F --git --group-directories-first --icons=auto"
      alias ll="eza -l -F --git --group-directories-first --icons=auto"
      alias lll="ll --git -g --header -a"
      alias tree="eza --tree"
      alias now="date --utc +%FT%TZ"
      alias rz="source ~/.zshrc && source ~/.zlogin && rehash"
      alias root='cd $(npm root)/..'
      alias forgit='alias | fzf -q forgit::'
      alias update-neovim='asdf uninstall neovim nightly && asdf install neovim nightly'
      forgit_checkout_commit='gcco'
      alias grom="git reset origin/$(git_main_branch)"

      alias tableflip="echo '(╯°□°)╯︵ ┻━┻' && yarn cache clean && rm -rf ./node_modules && yarn --check-files && yarn test --clearCache"
      alias vpn="(toggle-vpn && tmux refresh-client -S) &"
      alias ff="fzf -m --preview 'bat --style=numbers --color=always {} | head -500'"
      alias rw="rg --type web"
      alias nowrap="tput rmam"
      alias wrap="tput smam"

      # Use Raycast.app Spotify extension to "like" current song
      alias like="open raycast://extensions/mattisssa/spotify-player/likeCurrentSong"

      alias blog="cd ~/Documents/blog"

      alias ya="yadm add"
      alias yc="yadm commit"
      alias yp="yadm push"
      alias yst="yadm status"

      # eval "$(${pkgs.navi} widget zsh)"

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
      #   elif [[ ( -x $(which ton) ) && $\{#argv[@]} -gt 0 ]]; then
      #     ton $argv
      #   else
      #     vim $argv
      #   fi
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

      # Add custom scripts
      if [ -d "$HOME/.bin" ] ; then
        PATH="$PATH:$HOME/.bin"
      fi
      if [ -d "$HOME/.cargo/bin" ]; then
        PATH="$PATH:$HOME/.cargo/bin"
      fi
    '';
  };
}
