{ config, pkgs, lib, user, ... }:
{
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
		cdpath = [ "~/.local/share/src" ];
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
			. $HOME/.nix-profile/share/asdf-vm/asdf.sh

			# asdf plugin specific configs
			. ~/.asdf/plugins/golang/set-env.zsh
			export ASDF_GOLANG_MOD_VERSION_ENABLED=true
		'';
		initExtraBeforeCompInit = ''
			# asdf shell completions
			fpath=($ASDF_DIR/completions $fpath)
			# if type brew &>/dev/null; then
			#   FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
			# fi
			if [[ -e $HOME/.nix-profile ]]; then
			  FPATH="$HOME/.nix-profile/share/zsh/site-functions:$FPATH"
			fi
			autoload -Uz compinit && compinit
			autoload -Uz compaudit && compaudit
		'';
		completionInit = ''
			# Set up tab-completions
			compinit -i -C -d ~/.zcompdump*
			# set up 1password completions
			eval "$(op completion zsh)"; compdef _op op

			# Arrow key menu for completions
			zstyle ':completion:*' menu select

			# Case-insensitive (all),partial-word and then substring completion
			zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
		'';
		antidote.enable = true;
		antidote.plugins = [
			"laurenkt/zsh-vimto"

			"mdumitru/git-aliases"
			"wfxr/forgit"

			"Aloxaf/fzf-tab"
			"zdharma/fast-syntax-highlighting"
			"zsh-users/zsh-autosuggestions"
			"zsh-users/zsh-completions"
			"junegunn/fzf path:shell/key-bindings.zsh"
			"pschmitt/emoji-fzf.zsh"
			"ohmyzsh/ohmyzsh path:plugins/dotenv"
		];
		initExtra = ''
			forgit_checkout_commit='gcco'

			# Set Cache Dir for dotenv plugin
			export ZSH_CACHE_DIR="$HOME/.local/cache"

			# source ~/.zsh_profile # Load personal configs

			# # Load machine specific configs, if available
			# if [[ -a ~/.zsh_profile.local ]]; then
			#   source ~/.zsh_profile.local
			# fi

			# if [[ -a ~/.bin/tmuxinator.zsh ]]; then
			#   source ~/.bin/tmuxinator.zsh
			# fi

			# Add go binaries to PATH
			export PATH="$PATH:$HOME/go/bin"

			# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

			# if [[ -a /opt/homebrew/bin/thefuck ]]; then
			#   eval $(thefuck --alias)
			# fi
		'';

		loginExtra = ''
			export VISUAL=nvim
			export EDITOR="$VISUAL"

			export HOMEBREW_NO_ANALYTICS=1

			export BAT_THEME="ansi"
			export MANROFFOPT="-c"
			export MANPAGER="sh -c 'col -bx | bat -l man -p --color=always'"

			export FZF_DEFAULT_COMMAND="fd --type f --exclude '**/node_modules/*' --exclude '**/.git/*'"
			export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
			export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} | head -500'"
			export EMOJI_FZF_PREPEND_EMOJIS=1

			export FORGIT_FZF_DEFAULT_OPTS="
			--ansi
			--border
			--cycle
			--reverse
			"

			export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

			bindkey '^ ' autosuggest-accept
			bindkey '^P' up-line-or-search
			bindkey '^N' down-line-or-search
			bindkey '^X' clear-screen
			bindkey '^B' emoji-fzf-zle

			# alias sed="echo 'Did you mean to use sad?\r\n'; sed"

			alias l="eza -1 -F --git --group-directories-first --icons=auto"
			alias ll="eza -l -F --git --group-directories-first --icons=auto"
			alias lll="ll --git -g --header -a"
			alias tree="eza --tree"
			alias rz="source ~/.zshrc && source ~/.zsh_profile && rehash"
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

			function office() {
			  lights="6,8"

			  if [ "$1" = "up" ]; then
			    if [ "$2" != "" ]; then
			      echo "Increasing brightness $2%"
			      cmd="+$2%"
			    else
			      echo "Increasing brightness to 100%"
			      cmd="=100%"
			    fi
			  elif [ "$1" = "down" ]; then
			    if [ "$2" != "" ]; then
			      echo "Decreasing brightness $2%"
			      cmd="-$2%"
			    else
			      echo "Decreasing brightness 10%"
			      cmd="-10%"
			    fi
			  else
			    cmd="$1"
			  fi

			  hue lights $lights $cmd
			}

			function randomSha() {
			  local n = $1
			  for i in `seq $n`; do od -vAn -N2 -tu2 < /dev/urandom | sha1sum; done
			}

			function onsave() {
			   while true
			   do
			      eval "$1 &!"
			      trap "kill $! &> /dev/null; return;" SIGINT SIGTERM
			      # inotifywait -e modify -qq $2
			      watchman-wait $2
			      kill $! &> /dev/null
			   done
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
