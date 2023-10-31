unbind C-b
set -g prefix C-s

bind r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"

### SMART SPLITS
#############################

###### The following config comes from https://github.com/mrjones2014/smart-splits.nvim#tmux
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?|fzf)(diff)?$'"
bind-key -n C-h if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n C-j if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n C-k if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n C-l if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

bind-key -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 10'
bind-key -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 5'
bind-key -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 5'
bind-key -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 10'

bind-key -n M-H if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 2'
bind-key -n M-J if-shell "$is_vim" 'send-keys M-J' 'resize-pane -D 2'
bind-key -n M-K if-shell "$is_vim" 'send-keys M-K' 'resize-pane -U 2'
bind-key -n M-L if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 2'

tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R

bind-key -n M-> 'swap-window -t +1; select-window -t +1'
bind-key -n M-< 'swap-window -t -1; select-window -t -1'

### WINDOW/PANE MANAGEMENT
#############################
bind - split-window -v -c '#{pane_current_path}'
bind \\ split-window -h -c '#{pane_current_path}'
bind c new-window -c '#{pane_current_path}'
bind b break-pane -d

bind d kill-pane
bind x kill-window
bind = setw synchronize-panes

### MOUSE/COPY MODE
#############################

# https://github.com/tmux/tmux/issues/140
# disable "release mouse drag to copy and exit copy-mode", ref: https://github.com/tmux/tmux/issues/140
unbind-key -T copy-mode-vi MouseDragEnd1Pane

# since MouseDragEnd1Pane neither exit copy-mode nor clear selection now,
# let single click do selection clearing for us.
bind-key -T copy-mode-vi MouseDown1Pane select-pane\; send-keys -X clear-selection

# Setup 'v' to begin selection as in Vim
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
bind-key -T copy-mode-vi y send-keys -X copy-pipe "reattach-to-user-namespace pbcopy"

# Update default binding of `Enter` to also use copy-pipe
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe "reattach-to-user-namespace pbcopy"

### COMMANDS
#############################

# Switch Sessions
bind C-s split-window -v "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
bind C-m split-window -v "spt"

set -g @resurrect-save 'S'
set -g @resurrect-restore 'R'
