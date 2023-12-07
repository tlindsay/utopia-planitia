{ config, pkgs, lib, user, inputs, ... }:

let
  plugins = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix { inherit lib pkgs inputs; };
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;

    terminal = "tmux-256color";
    prefix = "C-s";
    keyMode = "vi";
    escapeTime = 10;
    historyLimit = 5000;

    baseIndex = 0;
    # renumberWindows = "on"; # no HM option for this...

    mouse = true;

    extraConfig = ''
      #############################
      ### STYLING, PROFILING
      #############################

      # Vertical Separator Char: "▍"
      set-option -g status-position top
      set -g status-fg black
      set -g status-bg brightmagenta
      set -g status-left "#[fg=black,bg=green,bold] #S "
      set -g status-left-length 100
      set -g status-right-length 140
      set -g status-right ""
      # set -ag status-right "#[reverse,blink]#{?pane_synchronized,*** PANES SYNCED! ***,}#[default]"
      set -ag status-right "#[bold]#{prefix_highlight}"
      # set -ag status-right "#[fg=black,bg=green,nobold]#(now-playing)"
      # set -ag status-right "#[fg=brightmagenta,bg=cyan]▍"
      # set -ag status-right "#[fg=black,bg=cyan]#(check-vpn && echo "" || echo "") #(ifconfig en0 inet | grep 'inet ' | awk '{print $2}') "
      # set -ag status-right "#[fg=brightmagenta,bg=cyan]▍"
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


      #############################
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
    '';

    plugins = [
      # {
      #   plugin = plugins.resurrect;
      #   extraConfig = ''
      #     set -g @resurrect-strategy-nvim 'session'
      #     set -g @resurrect-save 'S'
      #     set -g @resurrect-restore 'R'
      #   '';
      # }
      {
        plugin = plugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_fg 'pink'
          set -g @prefix_highlight_bg 'black'
          set -g @prefix_highlight_sync_prompt '󱍸 '
          set -g @prefix_highlight_show_sync_mode 'on'
        '';
      }
      # { plugin = plugins.better-mouse-mode; }
      # plugins.cowboy
      # plugins.tmux-menus
      # {
      #   plugin = plugins.session-wizard;
      #   extraConfig = ''
      #     set -g @session-wizard 'C-s'
      #   '';
      # }
      # plugins.open-nvim
      # {
      #   plugin = plugins.fingers;
      #   extraConfig = ''
      #     # Overrides matching file paths with :[line]:[col] at the end
      #     set -g @fingers-pattern-0 "((^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]+)(:[[:digit:]]*:[[:digit:]]*)?"
      #
      #     # Launches helper script on Ctrl+[key] in fingers mode
      #     set -g @fingers-ctrl-action "xargs -I {} tmux run-shell 'cd #{pane_current_path}; ~/.tmux/plugins/tmux-open-nvim/scripts/ton {} > ~/.tmux/plugins/tmux-open-nvim/ton.log'"s
      #   '';
      # }
    ];
  };
}
