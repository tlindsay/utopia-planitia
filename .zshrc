. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"
if [ -d "/opt/homebrew/bin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# # load asdf
# . $(brew --prefix asdf)/libexec/asdf.sh
#
# # asdf plugin specific configs
# . ~/.asdf/plugins/golang/set-env.zsh
# export ASDF_GOLANG_MOD_VERSION_ENABLED=true
#
# # asdf shell completions
# fpath=(${ASDF_DIR}/completions $fpath)
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Set up tab-completions
autoload -U compaudit compinit
compinit -i -C -d ~/.zcompdump*
# set up 1password completions
# eval "$(op completion zsh)"; compdef _op op

# Arrow key menu for completions
zstyle ':completion:*' menu select

# Case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

forgit_checkout_commit='gcco'

# Set Cache Dir for dotenv plugin
export ZSH_CACHE_DIR="$HOME/.local/cache"
# Load antibody plugins
if [[ -a ~/.zsh_bundle ]]; then
  source ~/.zsh_bundle
else
  antibody bundle < ~/.zsh_plugins > .zsh_bundle
  source ~/.zsh_bundle
fi

eval "$(starship init zsh)"

source ~/.zsh_profile # Load personal configs

# Load machine specific configs, if available
if [[ -a ~/.zsh_profile.local ]]; then
  source ~/.zsh_profile.local
fi

if [[ -a ~/.bin/tmuxinator.zsh ]]; then
  source ~/.bin/tmuxinator.zsh
fi

# Add go binaries to PATH
export PATH="$PATH:$HOME/go/bin"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -a /opt/homebrew/bin/thefuck ]]; then
  eval $(thefuck --alias)
fi

# Load z
# . /opt/homebrew/etc/profile.d/z.sh

# Added by eng-bootstrap 2022-03-17 17:35:15
export PATH=$PATH:/usr/local/google-cloud-sdk/bin

# Added by eng-bootstrap 2022-03-17 17:40:42
autoload -Uz compinit && compinit; eval "$(chef shell-init zsh)"

# Added by eng-bootstrap 2022-03-17 17:41:32
export PATH=$PATH:/usr/local/go/bin

# Added by eng-bootstrap 2022-03-17 17:46:02
export PATH=$PATH:/usr/local/google-cloud-sdk/bin

# Added by eng-bootstrap 2023-03-23 16:23:20
# export PATH=$PATH:/Users/plindsay/.asdf/installs/golang/1.20.2/packages/bin

# pnpm
# export PNPM_HOME="/Users/plindsay/Library/pnpm"
# export PATH="$PNPM_HOME:$PATH"
# pnpm end
# [ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh
