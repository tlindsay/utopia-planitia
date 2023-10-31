# Styling, profiling
# Vertical Separator Char: "▍"
set-option -g status-position top
set -g status-fg black
set -g status-bg brightmagenta
set -g status-left "#[fg=black,bg=blue,bold] #S "
set -g status-left-length 100
set -g status-right-length 140
set -g status-right ""
set -ag status-right "#[bold]#{prefix_highlight}"
set -ag status-right "#[fg=black,bg=green,nobold]#(now-playing)"
set -ag status-right "#[fg=brightmagenta,bg=cyan]▍"
set -ag status-right "#[fg=black,bg=cyan]#(check-vpn && echo "" || echo "") #(ifconfig en0 inet | grep 'inet ' | awk '{print $2}') "
set -ag status-right "#[fg=brightmagenta,bg=cyan]▍"
set -ag status-right "#[fg=black]%a %m/%d %l:%M %p "

setw -g window-status-format "#[fg=black,bg=brightmagenta] #I: #W "
setw -g window-status-current-format "#[fg=cyan,bg=black] #I: #W "

set -g clock-mode-style 12

set -g pane-border-status off
set -g pane-border-status bottom
set -g pane-border-format ""
set -g pane-border-style fg=magenta
set -g pane-active-border-style fg=cyan

set -g monitor-activity on
set -g window-status-activity-style bg=red,fg=white
set -g window-status-bell-style bg=default,fg=red,blink

set -g popup-border-lines rounded


