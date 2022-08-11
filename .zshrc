# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
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

# load asdf
. $(brew --prefix asdf)/libexec/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
# Set up tab-completions
autoload -U compaudit compinit
compinit -i -C -d ~/.zcompdump*

# Arrow key menu for completions
zstyle ':completion:*' menu select

# Case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

forgit_checkout_commit='gcco'
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
