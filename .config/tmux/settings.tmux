set -s default-terminal "tmux-256color"
set-option -g default-terminal "tmux-256color"
set-option -g status-keys "vi"
set-option -sg escape-time 10 # Setting this per Neovim#CheckHealth
set-option -g history-limit 5000

set -g base-index 0
set -g renumber-windows on

# Mouse mode
set-option -g mouse on

# Use vim keybindings in copy mode
setw -g mode-keys vi

# Trying to fix a few things
set-option -g default-command "reattach-to-user-namespace -l zsh"

# Undercurl https://github.com/folke/tokyonight.nvim/tree/main#fix-undercurls-in-tmux
set -g default-terminal "${TERM}"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

