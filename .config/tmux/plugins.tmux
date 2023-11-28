# PLUGINS!
set -g @plugin 'tmux-plugins/tpm'

set -g @plugin 'tmux-plugins/tmux-resurrect'

set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @prefix_highlight_fg 'pink'
set -g @prefix_highlight_bg 'black'

set -g @plugin 'nhdaly/tmux-better-mouse-mode'

# pew pew kill processes
set -g @plugin 'tmux-plugins/tmux-cowboy'

# More useful menus
set -g @plugin 'jaclu/tmux-menus'

# Session mgmt
set -g @plugin '27medkamal/tmux-session-wizard'

# Quick jumps in visual mode
set -g @plugin 'Morantron/tmux-fingers'

# Quick open files in adjacent pane
set -g @plugin 'trevarj/tmux-open-nvim'
# Overrides matching file paths with :[line]:[col] at the end
set -g @fingers-pattern-0 "((^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]+)(:[[:digit:]]*:[[:digit:]]*)?"
# Launches helper script on Ctrl+[key] in fingers mode
set -g @fingers-ctrl-action "xargs -I {} tmux run-shell 'cd #{pane_current_path}; ~/.tmux/plugins/tmux-open-nvim/scripts/ton {} > ~/.tmux/plugins/tmux-open-nvim/ton.log'"s

